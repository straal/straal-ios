//
/*
* ParseRedirectCallableSpec.swift
* Created by Michał Dąbrowski on 18/10/2019.
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

import Foundation
import Quick
import Nimble
@testable import Straal

class ParseRedirectCallableSpec: QuickSpec {
	override func spec() {
		describe("ParseRedirectCallable") {
			var data: Data!
			var response: HTTPURLResponse!
			var sut: ParseRedirectCallable { .init(response: SimpleCallable((data, response))) }

			beforeEach {
				data = Data(bytes: [0x22, 0x44])
			}

			afterEach {
				data = nil
				response = nil
			}

			context("when location is not available") {
				beforeEach {
					response = HTTPURLResponse(
						url: URL(string: "https://straal.com/")!,
						statusCode: 200,
						httpVersion: "1.1",
						headerFields: [:])
				}

				it("should throw an unknown error") {
					expect { try sut.call() }.to(throwError(StraalError.unknown))
				}
			}

			context("when location is available and valid") {
				beforeEach {
					response = HTTPURLResponse(
						url: URL(string: "https://straal.com/")!,
						statusCode: 200,
						httpVersion: "1.1",
						headerFields: ["Location": "https://redirect.straal.com/"])
				}

				it("should not throw any error") {
					expect { try sut.call() }.notTo(throwError())
				}

				it("should return parse url") {
					expect { try sut.call() }.to(equal(URL(string: "https://redirect.straal.com/")))
				}
			}
		}
	}
}
