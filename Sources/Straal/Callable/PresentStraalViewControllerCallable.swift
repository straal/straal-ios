//
/*
 * PresentStraalViewControllerCallable.swift
 * Created by Michał Dąbrowski on 19/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2020 Straal Sp. z o. o.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or  * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import Dispatch
import UIKit
import SafariServices

internal typealias PresentStraalViewControllerFactory = (
	AnyCallable<ThreeDSURLs>,
	@escaping (UIViewController) -> Void,
	@escaping (UIViewController) -> Void,
	AnyCallable<OpenURLContextRegistration>
) -> PresentStraalViewControllerCallable

typealias OpenURLHandlerFactory = (ThreeDSURLs, @escaping () -> Void, @escaping () -> Void) -> OpenURLContextHandler

class PresentStraalViewControllerCallable: Callable {
	private let urlsCallable: AnyCallable<ThreeDSURLs>
	private let present: (UIViewController) -> Void
	private let dismiss: (UIViewController) -> Void
	private let notificationRegistration: AnyCallable<OpenURLContextRegistration>
	private let notificationHandlerFactory: OpenURLHandlerFactory
	private let viewControllerFactory: (URL) -> SFSafariViewController

	convenience init(
		urls: AnyCallable<ThreeDSURLs>,
		present: @escaping (UIViewController) -> Void,
		dismiss: @escaping (UIViewController) -> Void,
		notificationRegistration: AnyCallable<OpenURLContextRegistration>
	) {
		self.init(
			urls: urls,
			present: present,
			dismiss: dismiss,
			notificationRegistration: notificationRegistration,
			notificationHandlerFactory: OpenURLContextParser.init,
			viewControllerFactory: SFSafariViewController.init
		)
	}

	init(
		urls: AnyCallable<ThreeDSURLs>,
		present: @escaping (UIViewController) -> Void,
		dismiss: @escaping (UIViewController) -> Void,
		notificationRegistration: AnyCallable<OpenURLContextRegistration>,
		notificationHandlerFactory: @escaping OpenURLHandlerFactory,
		viewControllerFactory: @escaping (URL) -> SFSafariViewController
	) {
		self.urlsCallable = urls.asCallable()
		self.present = present
		self.dismiss = dismiss
		self.notificationRegistration = notificationRegistration
		self.notificationHandlerFactory = notificationHandlerFactory
		self.viewControllerFactory = viewControllerFactory
	}

	func call() throws -> Encrypted3DSOperationStatus {
		let semaphore = DispatchSemaphore(value: 0)
		let urls = try urlsCallable.call()
		let registration = try notificationRegistration.call()
		var operationStatus: Encrypted3DSOperationStatus!
		let delegate = SafariViewControllerDelegate { [weak semaphore] in
			operationStatus = .failure
			semaphore?.signal()
		}
		let viewController: SFSafariViewController = viewControllerFactory(urls.redirectURL)
		viewController.delegate = delegate

		let onSuccess = { [semaphore, dismiss, viewController] in
			operationStatus = .success
			dismiss(viewController)
			semaphore.signal()
		}
		let onFailure = { [semaphore, dismiss, viewController] in
			operationStatus = .failure
			dismiss(viewController)
			semaphore.signal()
		}

		let urlHandler = notificationHandlerFactory(urls, onSuccess, onFailure)
		registration.register(handler: urlHandler)
		defer { registration.unregister(handler: urlHandler) }
		DispatchQueue.main.async { [present, viewController] in
			present(viewController)
		}
		semaphore.wait()
		return operationStatus
	}

}

private class SafariViewControllerDelegate: NSObject, SFSafariViewControllerDelegate {

	private let onCancel: () -> Void

	init(onCancel: @escaping () -> Void) {
		self.onCancel = onCancel
		super.init()
	}

	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		onCancel()
	}
}
