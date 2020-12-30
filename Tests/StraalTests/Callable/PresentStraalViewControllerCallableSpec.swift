//
/*
 * PresentStraalViewControllerCallableSpec.swift
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
			var init3DSContext: Init3DSContext!
			var presentCallCount: Int!
			var dismissCallCount: Int!
			var uniqueValue: UUID!
			var capturedPresentedViewController: UIViewController?
			var capturedDismissedViewController: UIViewController?
			var responseStatus: Encrypted3DSOperationStatus!
			var capturedStatus: Encrypted3DSOperationStatus!

			beforeEach {
				uniqueValue = UUID()
				responseStatus = nil
				let uuidString = uniqueValue.uuidString
				presentCallCount = 0
				dismissCallCount = 0
				capturedStatus = nil
				init3DSContext = Init3DSContext(
					redirectURL: URL(string: "https://sdk.straa.com/redirect")!,
					successURL: URL(string: "https://sdk.straa.com/success")!,
					failureURL: URL(string: "https://sdk.straa.com/failure")!)
				sut = PresentStraalViewControllerCallable(context: AnyCallable.of(init3DSContext)) { viewController in
					guard uniqueValue?.uuidString == uuidString else { return }
					presentCallCount += 1
					capturedPresentedViewController = viewController
					(viewController as? Straal3DSViewController)?.dismissWithResult(responseStatus)
				}
			}

			afterEach {
				capturedPresentedViewController = nil
				capturedDismissedViewController = nil
				responseStatus = nil
				uniqueValue = nil
				presentCallCount = nil
				dismissCallCount = nil
				init3DSContext = nil
				capturedStatus = nil
				sut = nil
			}

			it("should not call show by default") {
				expect(presentCallCount).to(equal(0))
			}

			context("when present is called and result is success") {
				beforeEach {
					responseStatus = .success
					waitUntil { done in
						DispatchQueue.global().async {
							capturedStatus = try? sut.call()
							done()
						}
					}
				}

				it("should eventually call present") {
					expect(presentCallCount).to(equal(1))
				}

				it("should pass straal view controller") {
					expect(capturedPresentedViewController).to(beAKindOf(Straal3DSViewController.self))
				}

				it("should return success status") {
					expect(capturedStatus).to(equal(.success))
				}
			}

			context("when present is called and result is failure") {
				beforeEach {
					responseStatus = .failure
					waitUntil { done in
						DispatchQueue.global().async {
							capturedStatus = try? sut.call()
							done()
						}
					}
				}

				it("should eventually call present") {
					expect(presentCallCount).to(equal(1))
				}

				it("should pass straal view controller") {
					expect(capturedPresentedViewController).to(beAKindOf(Straal3DSViewController.self))
				}

				it("should return failure status") {
					expect(capturedStatus).to(equal(.failure))
				}
			}
		}
	}
}
