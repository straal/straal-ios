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

class PresentStraalViewControllerCallable: Callable {
	private let operationContext: AnyCallable<Init3DSContext>
	private let present: (UIViewController) -> Void
	private let dismiss: (UIViewController) -> Void
	private let viewControllerFactory: (URL) -> SFSafariViewController

	init<O: Callable>(
		context: O,
		present: @escaping (UIViewController) -> Void,
		dismiss: @escaping (UIViewController) -> Void,
		viewControllerFactory: @escaping (URL) -> SFSafariViewController = SFSafariViewController.init)
	where O.ReturnType == Init3DSContext {
		self.operationContext = context.asCallable()
		self.present = present
		self.dismiss = dismiss
		self.viewControllerFactory = viewControllerFactory
	}

	func call() throws -> Encrypted3DSOperationStatus {
		let semaphore = DispatchSemaphore(value: 0)
		let context = try operationContext.call()
		var operationStatus: Encrypted3DSOperationStatus!
		let delegate = SafariViewControllerDelegate { [weak semaphore] in
			operationStatus = .unknown
			semaphore?.signal()
		}
		DispatchQueue.main.async { [delegate, present, viewControllerFactory] in
			let viewController = viewControllerFactory(context.redirectURL)
			viewController.delegate = delegate
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
