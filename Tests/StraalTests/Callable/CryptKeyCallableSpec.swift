/*
 * CryptKeyCallableSpec.swift
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

import Foundation
import Quick
import Nimble
import IDZSwiftCommonCrypto

@testable import Straal

class CryptKeyCallableSpec: QuickSpec {
	override func spec() {
		describe("CryptKeyCallable") {

			var sut: CryptKeyResponseCallable!
			let exampleResponse: [String: Any] = [
				"created_at": 1474370062 as NSNumber,
				"ttl": 600 as NSNumber,
				"id": "bvrjcfomhvfwy" as NSString,
				"key": "073f26135a0001f0b5865ee331c44c7722069d06ef0699525c1e6f06ee4a681fb7e00ccce7052cf14b0f7b498607156eae68e385305edc5338adad40aca442fec436cbed86d1a56d" as NSString,
				"permission": "v1.cards.create" as NSString
			]

			let expectedId: Data = dataFrom(hexString: "073f26135a0001f0")
			let expectedKey: Data = dataFrom(hexString: "b5865ee331c44c7722069d06ef0699525c1e6f06ee4a681fb7e00ccce7052cf1")
			let expectedIv1: Data = dataFrom(hexString: "4b0f7b498607156eae68e385305edc53")
			let expectedIv2: Data = dataFrom(hexString: "38adad40aca442fec436cbed86d1a56d")

			afterEach {
				sut = nil
			}

			beforeEach {
				sut = CryptKeyResponseCallable(response: SimpleCallable.of(exampleResponse))
			}

			it("should correctly parse cryptKey") {
				expect { try sut.call() }.notTo(throwError())
			}

			it("should correctly parse key id") {
				expect { try sut.call()[.id] }.to(equal(expectedId))
			}

			it("should correctly parse key value") {
				expect { try sut.call()[.key] }.to(equal(expectedKey))
			}

			it("should correctly parse key iv1") {
				expect { try sut.call()[.iv1] }.to(equal(expectedIv1))
			}

			it("should correctly parse key iv2") {
				expect { try sut.call()[.iv2] }.to(equal(expectedIv2))
			}

		}
	}
}
