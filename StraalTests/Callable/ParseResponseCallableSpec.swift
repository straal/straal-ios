/*
 * ParseResponseCallableSpec.swift
 * Created by Kajetan Dąbrowski on 24/01/2018.
 *
 * Straal SDK for iOS Tests
 * Copyright 2018 Straal Sp. z o. o.
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

class ParseResponseCallableSpec: QuickSpec {
	override func spec() {
		describe("Parse Error Callable") {
			var sut: ParseErrorCallable!
			let sampleJSON: [String: Any] = [
				"a": 1,
				"b": "123",
				"ccc": 4.222
			]

			let sampleArray: [String] = [
				"1", "2", "3"
			]

			let url = URL(string: "https://straal.com/endpoint")!
			func response(for status: Int) -> HTTPURLResponse {
				return HTTPURLResponse(url: url, statusCode: status, httpVersion: "1.1", headerFields: nil)!
			}
			let okResponse = response(for: 200)
			let badRequestResponse = response(for: 400)
			let paymentErrorResponse = response(for: 402)
			let notFoundResponse = response(for: 404)
			let unauthorizedResponse = response(for: 401)
			let forbiddenResponse = response(for: 403)
			let serverErrorResponse = response(for: 500)
			let badGatewayResponse = response(for: 502)

			afterEach {
				sut = nil
			}

			context("when status and json are ok") {
				beforeEach {
					guard let data = try? JSONSerialization.data(withJSONObject: sampleJSON) else { XCTFail("Unexpected JSON"); return }
					sut = ParseErrorCallable(response: SimpleCallable.of((data, okResponse)))
				}

				it("should not throw error") {
					expect { try sut.call() }.notTo(throwError())
				}

				it("should return dictionary with correct values") {
					expect { try sut.call() }.notTo(beNil())
				}
			}

			context("when status is server error") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), serverErrorResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when status is unauthorized") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), unauthorizedResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unauthorized))
				}
			}

			context("when status is forbidden") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), forbiddenResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when status is not found") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), notFoundResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.notFound))
				}
			}

			context("when status is bad request") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), badRequestResponse)))
				}

				it("should throw bad request error") {
					expect { try sut.call() }.to(throwError(StraalError.badRequest))
				}
			}

			context("when status is bad gateway") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), badGatewayResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.notFound))
				}
			}

			context("when status is payment error") {
				beforeEach {
					sut = ParseErrorCallable(response: SimpleCallable.of((Data(), paymentErrorResponse)))
				}

				it("should throw unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.payment))
				}
			}
		}
	}
}
