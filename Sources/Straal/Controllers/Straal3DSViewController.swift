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

internal class Straal3DSViewController: SFSafariViewController {

	// MARK: Properties
	var cancel: ((UIViewController) -> Void)?

	override var delegate: SFSafariViewControllerDelegate? {
		didSet {
			assert(delegate === self)
		}
	}

	override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
		super.init(url: URL, configuration: configuration)
		delegate = self
	}

	convenience init(url URL: URL) {
		self.init(url: URL, configuration: .init())
	}
}

extension Straal3DSViewController: SFSafariViewControllerDelegate {
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		// TODO
		// Nothing we can do now. This will only be called when the user cancels the presentation
		// For now we cannot detect what happened.
//		dismissWithResult(.unknown)
		cancel?(self)
	}
}
