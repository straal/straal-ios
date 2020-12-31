//
/*
 * PresentStraalViewControllerCallableSpec.swift
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
// swiftlint:disable function_body_length
import Foundation
import UIKit
import SafariServices
import Quick
import Nimble
@testable import Straal

class PresentStraalViewControllerCallableSpec: QuickSpec {
	override func spec() {
		describe("PresentStraalViewControllerCallable") {

			var sut: PresentStraalViewControllerCallable!
			var init3DSURLs: Init3DSURLs!
			var presentCallCount: Int!
			var dismissCallCount: Int!
			var uniqueValue: UUID!
			var capturedPresentedViewController: UIViewController?
			var capturedDismissedViewController: UIViewController?
			var capturedStatus: Encrypted3DSOperationStatus!
			var capturedURL: URL?

			beforeEach {
				uniqueValue = UUID()
				let uuidString = uniqueValue.uuidString
				presentCallCount = 0
				dismissCallCount = 0
				capturedStatus = nil
				init3DSURLs = Init3DSContext(
					redirectURL: URL(string: "https://sdk.straa.com/redirect")!,
					successURL: URL(string: "https://sdk.straa.com/success")!,
					failureURL: URL(string: "https://sdk.straa.com/failure")!)
				sut = PresentStraalViewControllerCallable(
					context: AnyCallable.of(init3DSURLs),
					present: { viewController in
						guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
						presentCallCount += 1
						let safariViewController = viewController as? SFSafariViewController
						capturedPresentedViewController = viewController
						safariViewController?.delegate?.safariViewControllerDidFinish?(safariViewController!)
					}, dismiss: { viewController in
						guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
						dismissCallCount += 1
						capturedDismissedViewController = viewController
					}, viewControllerFactory: { url in
						capturedURL = url
						return SafariViewControllerSpy(url: url)
					})
			}

			afterEach {
				capturedPresentedViewController = nil
				capturedDismissedViewController = nil
				uniqueValue = nil
				presentCallCount = nil
				dismissCallCount = nil
				init3DSURLs = nil
				capturedStatus = nil
				capturedURL = nil
				sut = nil
			}

			it("should not call show by default") {
				expect(presentCallCount).to(equal(0))
			}

			context("when present is called and completed") {
				beforeEach {
					waitUntil { done in
						DispatchQueue.global().async {
							capturedStatus = try? sut.call()
							done()
						}
					}
				}

				it("should call present once") {
					expect(presentCallCount).to(equal(1))
				}

				it("should not call dismiss") {
					expect(dismissCallCount).to(equal(0))
					expect(capturedDismissedViewController).to(beNil())
				}

				it("should present view controller from factory") {
					expect(capturedPresentedViewController).to(beAKindOf(SafariViewControllerSpy.self))
				}

				it("should return unknown status") {
					expect(capturedStatus).to(equal(.unknown))
				}

				it("should present correct url") {
					expect(capturedURL?.absoluteString).to(equal("https://sdk.straa.com/redirect"))
				}
			}
		}
	}

}
