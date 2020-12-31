/*
 * PostRequestCallableSpec.swift
 * Created by Bartosz Kamiński on 26/01/2018.
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

import Foundation
import Quick
import Nimble

@testable import Straal

class PostRequestCallableSpec: QuickSpec {
	override func spec() {
		describe("PostRequestCallable") {
			var sut: PostRequestCallable!
			var versionAdapterFake: VersionAdapterFake!

			beforeEach {
				versionAdapterFake = VersionAdapterFake()
			}

			afterEach {
				sut = nil
				versionAdapterFake = nil
			}

			context("when called with url, body and custom headers") {
				let url = URL(string: "https://straal.com/endpoint")!
				let body = Data()
				let version = "1.1.2"
				let customHeaders = ["user_uuid": "2309er9wjfsd",
									 "order_uuid": "kk0d30e3kee"]

				var returnedRequest: URLRequest?

				beforeEach {
					versionAdapterFake.versionToReturn = version
					sut = PostRequestCallable(body: body, url: url, headers: customHeaders)
					sut.versionAdapter = versionAdapterFake
					returnedRequest = try? sut.call()
				}

				it("should not throw error") {
					expect { try sut.call() }.notTo(throwError())
				}

				it("should have correct url") {
					expect(returnedRequest?.url).to(equal(url))
				}

				it("should be POST") {
					expect(returnedRequest?.httpMethod).to(equal("POST"))
				}

				it("should have provided body") {
					expect(returnedRequest?.httpBody).to(equal(body))
				}

				it("should have 3 default headers and 2 custom") {
					expect(returnedRequest?.allHTTPHeaderFields).to(haveCount(5))
				}

				it("should have correct default headers") {
					expect(returnedRequest?.value(forHTTPHeaderField: "content-type")).to(equal("application/json"))
					expect(returnedRequest?.value(forHTTPHeaderField: "x-straal-sdk-version")).to(equal(version))
					expect(returnedRequest?.value(forHTTPHeaderField: "x-straal-sdk-platform")).to(equal("ios"))
				}

				it("should have correct custom headers") {
					customHeaders.forEach { customHeader in
						expect(returnedRequest?.value(forHTTPHeaderField: customHeader.key)).to(equal(customHeader.value))
					}
				}
			}
		}
	}
}
