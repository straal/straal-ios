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
			var capturedOnSuccess: (() -> Void)?
			var capturedOnFailure: (() -> Void)?
			var urlRegistrationFake: OpenURLContextRegistrationFake!
			var urlContextHandlerFake: OpenURLContextHandlerFake!

			var presentAndCancelByUser: ((UIViewController) -> Void)!

			var presentAndSucceed: ((UIViewController) -> Void)!
			var presentAndFail: ((UIViewController) -> Void)!
			var dismiss: ((UIViewController) -> Void)!
			var handlerFactory: OpenURLHandlerFactory!
			var safariFactory: ((URL) -> SFSafariViewController)!

			beforeEach {
				uniqueValue = UUID()
				let uuidString = uniqueValue.uuidString
				presentCallCount = 0
				dismissCallCount = 0
				capturedStatus = nil
				capturedOnSuccess = nil
				capturedOnFailure = nil
				urlRegistrationFake = .init()
				urlContextHandlerFake = .init()
				init3DSURLs = Init3DSURLs(
					redirectURL: URL(string: "https://sdk.straa.com/redirect")!,
					successURL: URL(string: "https://sdk.straa.com/success")!,
					failureURL: URL(string: "https://sdk.straa.com/failure")!
				)
				presentAndCancelByUser = { viewController in
					guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
					presentCallCount += 1
					let safariViewController = viewController as? SFSafariViewController
					capturedPresentedViewController = viewController
					safariViewController?.delegate?.safariViewControllerDidFinish?(safariViewController!)
				}
				presentAndSucceed = { viewController in
					guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
					presentCallCount += 1
					capturedPresentedViewController = viewController
					Thread.sleep(forTimeInterval: 0.1)
					guard let success = capturedOnSuccess else {
						XCTFail("Success not handled"); return
					}
					success()
				}
				presentAndFail = { viewController in
					guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
					presentCallCount += 1
					capturedPresentedViewController = viewController
					//					Thread.sleep(until: .now() + .milliseconds(100))
					Thread.sleep(forTimeInterval: 0.1)
					guard let fail = capturedOnFailure else {
						XCTFail("Success not handled"); return
					}
					fail()
				}
				dismiss = { viewController in
					guard uniqueValue?.uuidString == uuidString else { XCTFail("Invalid test!"); return }
					dismissCallCount += 1
					capturedDismissedViewController = viewController
				}
				safariFactory = { url in
					capturedURL = url
					return SafariViewControllerSpy(url: url)
				}
				handlerFactory = { _, onSuccess, onFailure in
					capturedOnSuccess = onSuccess
					capturedOnFailure = onFailure
					return urlContextHandlerFake
				}
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
				capturedOnSuccess = nil
				capturedOnFailure = nil
				urlRegistrationFake = nil
				urlContextHandlerFake = nil
				safariFactory = nil
				handlerFactory = nil
				presentAndCancelByUser = nil
				presentAndSucceed = nil
				presentAndFail = nil
				dismiss = nil
				sut = nil
			}

			it("should not call show by default") {
				expect(presentCallCount).to(equal(0))
			}

			context("when present is called and cancelled by user") {
				beforeEach {
					sut = PresentStraalViewControllerCallable(
						urls: AnyCallable.of(init3DSURLs),
						present: presentAndCancelByUser,
						dismiss: dismiss,
						notificationRegistration: AnyCallable.of(urlRegistrationFake).asCallable(),
						notificationHandlerFactory: handlerFactory,
						viewControllerFactory: safariFactory
					)

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

				it("should return failure status") {
					expect(capturedStatus).to(equal(.failure))
				}

				it("should present correct url") {
					expect(capturedURL?.absoluteString).to(equal("https://sdk.straa.com/redirect"))
				}

				it("should register once for urls") {
					expect(urlRegistrationFake.registerCalled).to(haveCount(1))
				}

				it("should register object returned from factory") {
					expect(urlRegistrationFake.registerCalled.first).to(be(urlContextHandlerFake))
				}

				it("should deregister once for urls") {
					expect(urlRegistrationFake.unregisterCalled).to(haveCount(1))
				}

				it("should deregister object returned from factory") {
					expect(urlRegistrationFake.unregisterCalled.first).to(be(urlContextHandlerFake))
				}
			}

			context("when present is called and succeeds") {
				beforeEach {
					sut = PresentStraalViewControllerCallable(
						urls: AnyCallable.of(init3DSURLs),
						present: presentAndSucceed,
						dismiss: dismiss,
						notificationRegistration: AnyCallable.of(urlRegistrationFake).asCallable(),
						notificationHandlerFactory: handlerFactory,
						viewControllerFactory: safariFactory
					)

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

				it("should call dismiss") {
					expect(dismissCallCount).to(equal(1))
					expect(capturedDismissedViewController).to(beAKindOf(SafariViewControllerSpy.self))
				}

				it("should present view controller from factory") {
					expect(capturedPresentedViewController).to(beAKindOf(SafariViewControllerSpy.self))
				}

				it("should return success status") {
					expect(capturedStatus).to(equal(.success))
				}

				it("should present correct url") {
					expect(capturedURL?.absoluteString).to(equal("https://sdk.straa.com/redirect"))
				}

				it("should register once for urls") {
					expect(urlRegistrationFake.registerCalled).to(haveCount(1))
				}

				it("should register object returned from factory") {
					expect(urlRegistrationFake.registerCalled.first).to(be(urlContextHandlerFake))
				}

				it("should deregister once for urls") {
					expect(urlRegistrationFake.unregisterCalled).to(haveCount(1))
				}

				it("should deregister object returned from factory") {
					expect(urlRegistrationFake.unregisterCalled.first).to(be(urlContextHandlerFake))
				}
			}

			context("when present is called and fails") {
				beforeEach {
					sut = PresentStraalViewControllerCallable(
						urls: AnyCallable.of(init3DSURLs),
						present: presentAndFail,
						dismiss: dismiss,
						notificationRegistration: AnyCallable.of(urlRegistrationFake).asCallable(),
						notificationHandlerFactory: handlerFactory,
						viewControllerFactory: safariFactory
					)

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

				it("should call dismiss") {
					expect(dismissCallCount).to(equal(1))
					expect(capturedDismissedViewController).to(beAKindOf(SafariViewControllerSpy.self))
				}

				it("should present view controller from factory") {
					expect(capturedPresentedViewController).to(beAKindOf(SafariViewControllerSpy.self))
				}

				it("should return failed status") {
					expect(capturedStatus).to(equal(.failure))
				}

				it("should present correct url") {
					expect(capturedURL?.absoluteString).to(equal("https://sdk.straa.com/redirect"))
				}

				it("should register once for urls") {
					expect(urlRegistrationFake.registerCalled).to(haveCount(1))
				}

				it("should register object returned from factory") {
					expect(urlRegistrationFake.registerCalled.first).to(be(urlContextHandlerFake))
				}

				it("should deregister once for urls") {
					expect(urlRegistrationFake.unregisterCalled).to(haveCount(1))
				}

				it("should deregister object returned from factory") {
					expect(urlRegistrationFake.unregisterCalled.first).to(be(urlContextHandlerFake))
				}
			}
		}
	}
}
