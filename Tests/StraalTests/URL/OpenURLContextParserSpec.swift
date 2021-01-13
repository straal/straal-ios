/*
* OpenURLContextParserSpec.swift
* Created by Michał Dąbrowski on 31/12/2020.
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
import Quick
import Nimble

@testable import Straal

class OpenURLContextParserSpec: QuickSpec {

	override func spec() {

		describe("OpenURLContextParser") {
			var sut: OpenURLContextParser!
			var successCalled: Int!
			var failureCalled: Int!
			let successURL: URL = URL(string: "https://domain.com/x-callback-url/straal/success")!
			let failureURL = URL(string: "https://domain.com/x-callback-url/straal/failure")!
			let redirectURL = URL(string: "https://straal.com/webpay/aliuterif")!

			beforeEach {
				successCalled = 0
				failureCalled = 0
				sut = .init(
					urls: .init(
						redirectURL: redirectURL,
						successURL: successURL,
						failureURL: failureURL),
					onSuccess: { successCalled += 1 },
					onFailure: { failureCalled += 1 }
				)
			}

			afterEach {
				successCalled = nil
				failureCalled = nil
				sut = nil
			}

			describe("redirect url") {
				beforeEach {
					sut.handle(.init(url: redirectURL))
				}

				it("should not call success") {
					expect(successCalled).to(equal(0))
				}

				it("should not call failure") {
					expect(failureCalled).to(equal(0))
				}
			}

			describe("success url") {
				beforeEach {
					sut.handle(.init(url: successURL))
				}

				it("should call success") {
					expect(successCalled).to(equal(1))
				}

				it("should not call failure") {
					expect(failureCalled).to(equal(0))
				}
			}

			describe("failure url") {
				beforeEach {
					sut.handle(.init(url: failureURL))
				}

				it("should not call success") {
					expect(successCalled).to(equal(0))
				}

				it("should call failure") {
					expect(failureCalled).to(equal(1))
				}
			}

			describe("some other url with same scope url") {
				beforeEach {
					let url = URL(string: "https://domain.com/x-callback-url/daftmobile/success")!
					sut.handle(.init(url: url))
				}

				it("should not call success") {
					expect(successCalled).to(equal(0))
				}

				it("should not call failure") {
					expect(failureCalled).to(equal(0))
				}
			}
		}
	}

}
