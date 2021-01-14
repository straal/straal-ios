/*
 * HttpCallableSpec.swift
 * Created by Bartosz Kamiński on 25/01/2018.
 *
 * Straal SDK for iOS Tests
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

class HttpCallableSpec: QuickSpec {
	override func spec() {
		describe("HttpCallable") {
			var sut: HttpCallable!
			var urlSessionAdapterFake: UrlSessionAdapterFake!
			var operationContextContainerFake: OperationContextContainerFake!
			var configuration: StraalConfiguration!

			let url = URL(string: "https://straal.com/endpoint")!
			let request = URLRequest(url: url)
			let correctData = Data()
			let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil)!

			beforeEach {
				operationContextContainerFake = .init()
				urlSessionAdapterFake = UrlSessionAdapterFake()
				configuration = StraalConfiguration(baseUrl: URL(string: "https://api.backend.com")!, urlSession: urlSessionAdapterFake, operationContextContainer: operationContextContainerFake)
			}

			afterEach {
				sut = nil
				urlSessionAdapterFake = nil
				operationContextContainerFake = nil
			}

			context("when data and response are correct") {

				var result: (Data, HTTPURLResponse)?

				beforeEach {
					urlSessionAdapterFake.synchronousDataTasksToReturn = [(correctData, httpResponse, nil), (correctData, httpResponse, nil)]
					sut = HttpCallable(requestSource: SimpleCallable.of(request), configuration: configuration)
					result = try? sut.call()
				}

				it("session adapter should receive correct request") {
					expect(urlSessionAdapterFake.synchronousDataTaskCapturedRequests.first).to(equal(request))
				}

				it("should not throw error") {
					expect { try sut.call() }.notTo(throwError())
				}

				it("should return correct data and response") {
					expect(result?.0).to(equal(correctData))
					expect(result?.1).to(equal(httpResponse))
				}
			}

			context("when response isn't http") {

				let otherResponse = URLResponse(url: url, mimeType: "application/json", expectedContentLength: 10, textEncodingName: nil)

				beforeEach {
					urlSessionAdapterFake.synchronousDataTasksToReturn = [(correctData, otherResponse, nil)]
					sut = HttpCallable(requestSource: SimpleCallable.of(request), configuration: configuration)
				}

				it("should throw Straal unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when data is nil") {

				beforeEach {
					urlSessionAdapterFake.synchronousDataTasksToReturn = [(nil, httpResponse, nil)]
					sut = HttpCallable(requestSource: SimpleCallable.of(request), configuration: configuration)
				}

				it("should throw Straal unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when there's an error") {

				let error = StraalError.invalidResponse

				beforeEach {
					urlSessionAdapterFake.synchronousDataTasksToReturn = [(nil, nil, error)]
					sut = HttpCallable(requestSource: SimpleCallable.of(request), configuration: configuration)
				}

				it("should throw the same error") {
					expect { try sut.call() }.to(throwError(error))
				}
			}
		}
	}
}
