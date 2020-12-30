/*
 * CryptorSpec.swift
 * Created by Kajetan Dąbrowski on 09/09/16.
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
import XCTest

@testable import Straal

class CryptorSpec: QuickSpec {
	override func spec() {
		describe("CryptorSpec") {

			var sut: StraalCryptor!

			beforeEach {
				sut = StraalCryptor()
			}

			afterEach {
				sut = nil
			}

			describe("example 1") {

				let cryptKey: CryptKey! = try? CryptKey(cryptKeyString: "06fc9aef59800254162a505ca9fe7fb4c8a604b596a23dcc3182a29ca7234b69f6c7e5b33b7c57c9e09f6908fd1a364fdaf25d5fa2be9a31f25291f204a08b03065ccbb54ab1852b")
				let requestString: String = "{\"card\":{\"number\":\"4111111111111111\",\"cvv\":\"123\",\"expiry_month\":10,\"expiry_year\":2123},\"cardholder\":{\"name\":\"test_cardholder\",\"email\":\"test_cardholder@testing.com\",\"ipaddr\":\"37.157.203.70\",\"reference\":\"foo_user\"}}"
				let encryptedRequest: Data = "06fc9aef598002540ed0421fe77b626aeac319bed1157519703c3bbe09307ba383baf8f80cbaeb324d6c53f96a6fa4d9d73fb400a365a13a1ff13524326b88115439d9a0a9c157c1f040756dcf975ea0153eb8b93c545cd823f3f2e8907737fe6dab706cbc2078dd20af1a37d7722ada25b67b82445fb4eb6d0e18fa37a67e45e1c0a276bcb0b4b71a160dc167e4ab1725fc524c8947f07385624791a6d4a18e929307448d3e8f827243d34ba61736ff45b9c2e38ffc26b5556fddf8bf074686bf1b4d47e8dea4547b7ace02f25a19391ba4ce72eb002d4976b60d5435c39276e76f164c0e87ce3e".data(using: .ascii)!

				let encryptedResponse: Data = "06fc9aef59800254b81d68b39540103c66cd9ad6b4585cf8a2f3b15e302c9875e9ecdabc16a9afe32bbca39d6c7b5d8c4ffc39fdf2a0b2ea709e2d39ed8bc7279eb0959d7ab6d6b9a3c40e99aa15fa91a9457a405514c625f0f86e7f649e452d4c859a0f91f1f48b4a69ae38a2234829fac56b975dab012e03518ef214dbeb4beaf22a4199b045bf6ee2f893e6479b2ae44c2e99ef84d821e4a19d4999fdcd0a76c84410c311db24bf976a36873f2d27e7230805d5b7f1f78c1466042d9622f33eca03fc368d9d6d".data(using: .ascii)!

				let decryptedResponse: [String: Any] = ["num_last_4": "1111", "num_bin": "411111", "expiry_month": 10, "expiry_year": 2123, "created_at": 1472137232, "cardholder": ["id": "a8zff8v3pvibu"], "brand": "visa", "id": "37ffasfxptibu"]

				it("should correctly parse crypt key") {
					expect(cryptKey).notTo(beNil())
				}

				it("should correctly encrypt string") {
					expect(try? sut.encrypt(message: requestString, key: cryptKey)).to(equal(encryptedRequest))
				}

				it("should correctly decrypt response") {
					guard let decryptedString = try? sut.decrypt(data: encryptedResponse, key: cryptKey) else { XCTFail("Decryption failed"); return }
					guard let jsonObject = try? JSONSerialization.jsonObject(with: decryptedString.data(using: String.Encoding.utf8)!, options: []),
						let jsonDict = jsonObject as? [String: Any] else { XCTFail("Unexpected JSON"); return }
					expect((decryptedResponse as NSDictionary).isEqual(to: jsonDict)).to(beTrue())
				}
			}

			describe("Invalid encrypted response") {
				let encryptedInvalidResponse: Data = "06fc9b6e24000256fd94cb4e2cf9e4d53ad645751c9e64fb479f4e233795a228e445486b546237dd7ad956a90bd66e5d676a856a2cdff8d2fbb1a531620497e53029e563fdf4636e75ad1ab2a7dd47ad48d2fc69f0be396571604f6c1ea7c6f3754c4721c10731db3273884b39529a0ae90397dee0561b9bcfc16936b34b57028f7e265602713ef186f6f23be972cb39d0aa2ad95b94df2f419eb3fff3d546f3c50907dd8bcaa0a06e2f798242cd900a60c9666f5fd31069c8bdd021f36e11c93abfab94711a9a35abab1238091230".data(using: .ascii)!

				let cryptKey: CryptKey? = try? CryptKey(cryptKeyString: "06fc9b6e24000256b61c6d91d1333932283370ecca62ae6c551745545a1918d0a7c67a58143ee503c850ad861f2d2683052876cf90a64688211b5dd8caef0969dcc887dc5a31e34b")

				it("should throw a correct error") {
					guard let key = cryptKey else { XCTFail("Unexpected key"); return }
					expect { try sut.decrypt(data: encryptedInvalidResponse, key: key) }.to(throwError(StraalCryptor.CryptorError.invalidMessage))
				}
			}

			describe("Invalid key") {
				let encryptedInvalidResponse: Data = "06fc9b6e24000256fd94cb4e2cf9e4d53ad645751c9e64fb479f4e233795a228e445486b546237dd7ad956a90bd66e5d676a856a2cdff8d2fbb1a531620497e53029e563fdf4636e75ad1ab2a7dd47ad48d2fc69f0be396571604f6c1ea7c6f3754c4721c10731db3273884b39529a0ae90397dee0561b9bcfc16936b34b57028f7e265602713ef186f6f23be972cb39d0aa2ad95b94df2f419eb3fff3d546f3c50907dd8bcaa0a06e2f798242cd900a60c9666f5fd31069c8bdd021f36e11c93abfab94711a9a35".data(using: .ascii)!

				let cryptKey: CryptKey? = try? CryptKey(cryptKeyString: "07fc9b6e24000256b61c6d91d1333932283370ecca62ae6c551745545a1918d0a7c67a58143ee503c850ad861f2d2683052876cf90a64688211b5dd8caef0969dcc887dc5a31e34b")

				it("should throw a correct error") {
					guard let key = cryptKey else { XCTFail("Unexpected key"); return }
					expect { try sut.decrypt(data: encryptedInvalidResponse, key: key) }.to(throwError(StraalCryptor.CryptorError.invalidKey))
				}
			}

			describe("Generic key") {
				let cryptKey: CryptKey? = try? CryptKey(cryptKeyString: "06fc9b6e24000256b61c6d91d1333932283370ecca62ae6c551745545a1918d0a7c67a58143ee503c850ad861f2d2683052876cf90a64688211b5dd8caef0969dcc887dc5a31e34b")

				it("should throw error when message is empty") {
					guard let key = cryptKey else { XCTFail("Unexpected key"); return }
					expect { try sut.decrypt(data: Data(), key: key) }.to(throwError(StraalCryptor.CryptorError.invalidMessage))
				}
			}

		}
	}
}
