//
/*
 * Straal3DSViewController.swift
 * Created by Michał Dąbrowski on 19/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2019 Straal Sp. z o. o.
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

import UIKit
import SafariServices

internal final class Straal3DSViewController: SFSafariViewController {

	// MARK: Properties
	private let completion: (Encrypted3DSOperationStatus) -> Void
	private let context: Init3DSContext
	private var result: Encrypted3DSOperationStatus?

	override var delegate: SFSafariViewControllerDelegate? {
		didSet {
			assert(delegate === self)
		}
	}

	init(context: Init3DSContext, completion: @escaping (Encrypted3DSOperationStatus) -> Void) {
		self.context = context
		self.completion = completion
		super.init(url: context.redirectURL, configuration: .init())
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.delegate = self
	}

	// MARK: Private

	private func callCompletion() {
		completion(result ?? .failure)
	}

	internal func dismissWithResult(_ result: Encrypted3DSOperationStatus) {
		guard self.result == nil else { fatalError("Result already determined") }
		self.result = result
		dismissWithCompletion()
	}

	private func dismissWithCompletion() {
		dismiss(animated: true) { () in self.callCompletion() }
	}
}

extension Straal3DSViewController: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		// TODO
		// Nothing we can do now. This will only be called when the user cancels the presentation
		// For now we cannot detect what happened.
		dismissWithResult(.unknown)
	}
}
