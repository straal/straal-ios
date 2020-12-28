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

// swiftlint:disable function_body_length

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
				let encryptedRequest: Data = hexString(fromArray: Data(hexString: "06fc9aef598002540ed0421fe77b626aeac319bed1157519703c3bbe09307ba383baf8f80cbaeb324d6c53f96a6fa4d9d73fb400a365a13a1ff13524326b88115439d9a0a9c157c1f040756dcf975ea0153eb8b93c545cd823f3f2e8907737fe6dab706cbc2078dd20af1a37d7722ada25b67b82445fb4eb6d0e18fa37a67e45e1c0a276bcb0b4b71a160dc167e4ab1725fc524c8947f07385624791a6d4a18e929307448d3e8f827243d34ba61736ff45b9c2e38ffc26b5556fddf8bf074686bf1b4d47e8dea4547b7ace02f25a19391ba4ce72eb002d4976b60d5435c39276e76f164c0e87ce3e")!.bytesArray).data(using: .ascii)!

				let encryptedResponse: Data = hexString(fromArray: Data(hexString: "06fc9aef59800254b81d68b39540103c66cd9ad6b4585cf8a2f3b15e302c9875e9ecdabc16a9afe32bbca39d6c7b5d8c4ffc39fdf2a0b2ea709e2d39ed8bc7279eb0959d7ab6d6b9a3c40e99aa15fa91a9457a405514c625f0f86e7f649e452d4c859a0f91f1f48b4a69ae38a2234829fac56b975dab012e03518ef214dbeb4beaf22a4199b045bf6ee2f893e6479b2ae44c2e99ef84d821e4a19d4999fdcd0a76c84410c311db24bf976a36873f2d27e7230805d5b7f1f78c1466042d9622f33eca03fc368d9d6d")!.bytesArray).data(using: .ascii)!

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

			describe("example 2") {

				let cryptKey: CryptKey! = try? CryptKey(cryptKeyString: "06fc9b218f0002556379f8ace1a340583333dc60f2bede2474d1d1fe0792d8cfa87b11a0dd6b3e6561f9ffa05cecbe1ef46d0407c92483c4a660a0691151d80bf74aa11c9aebddc6")
				let requestString: String = "{\"card\":{\"number\":\"4111111111111111\",\"cvv\":\"123\",\"expiry_month\":12,\"expiry_year\":2019},\"cardholder\":{\"name\":\"test_cardholder2\",\"email\":\"test_cardholder2@testing.com\",\"ipaddr\":\"37.157.203.70\",\"reference\":\"foo_user\"}}"
				let encryptedRequest: Data = hexString(fromArray: Data(hexString: "06fc9b218f000255f1bef4dcc51ce61d164e70cd01a1625857ec6519388e020261836d183cff3316b673b5b7a37730203057118c871f498626e86b9e548f46debbfc815c1de204df63a7f95b317c86c94a963739140a39d7a0b6b5fea28c371c560bb690e88d94dd8fe86cc6b28ae0e1cc75f6ce511c164c4b4334a45e350f8785c50e40bad08f5614729bd9c269ae6c4eb6d59e1e85459b2aa291a4c8a3abbe97ee917600666cfb1a9ce00774f6f8cb2e85f7defd64aefb1d43837bc923e90bafce32d3434beed4449dafea7194201029ea0e0e697036d0ed6e3612332eda9c352855d887bbdd90")!.bytesArray).data(using: .ascii)!

				let encryptedResponse: Data = hexString(fromArray: Data(hexString: "06fc9b218f000255a01f457d1af7f4f517b9c5a55475596c63dc15fe6c29a1bceb1eda410d68f0b3b428877ba1a89fcad41ab74a3be9692372a9d905f46b0445718c1be9834caf137ee048d77ddde5a8db934aea242e4c14b5d239d9b29c24bf17d355b38084be22e3034f298d2e4f59060bef296bfa45baea3eaf613c341959cd49de97be625005aa7b4bddbc3bfab9e34cbcf89d2c79e373c56dce1fa030a7224452b88556d94f759cdb805bd3c3b586e11c7553e2d811a079a55b12b1f8d99c4340a57bc44f2f")!.bytesArray).data(using: .ascii)!

				let decryptedResponse: [String: Any] = ["num_last_4": "1111", "num_bin": "411111", "expiry_month": 12, "expiry_year": 2019, "created_at": 1472137257, "cardholder": ["id": "f6v1fxp9naib1"], "brand": "visa", "id": "1ffffit9ma7b3"]

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

			describe("example 3") {

				let cryptKey: CryptKey! = try? CryptKey(cryptKeyString: "06fc9b6e24000256b61c6d91d1333932283370ecca62ae6c551745545a1918d0a7c67a58143ee503c850ad861f2d2683052876cf90a64688211b5dd8caef0969dcc887dc5a31e34b")
				let requestString: String = "{\"card\":{\"number\":\"4111111111111111\",\"cvv\":\"123\",\"expiry_month\":12,\"expiry_year\":2019},\"cardholder\":{\"name\":\"電电電電电電電电\",\"email\":\"test_cardholder2@testing.com\",\"ipaddr\":\"37.157.203.70\",\"reference\":\"foo_user\"}}"
				let encryptedRequest: Data = hexString(fromArray: Data(hexString: "06fc9b6e24000256fb7757c0a8cfe10c1938951afa02e1e048561be5e2ebd7e0f8cfbc3c6606179710ba36ca2285dd3835f2deff304f31f0596ee9a7e43fef5231897462be3ec20aa4ce2fb2b2bd087f46c2f8f3a82aea96193b9c979d2ac36def3d7e63c121cc0b54f9e1cf6cde4e88ff0fedc1da0e2cb58b2d910eebc0b47b75dd74aacb401d728ba4d2b277ffc22bdd00658a2be09edb408b10795be544456b72265c895db646e032e3fd678c19fa0d661e1d95aea1dedef9022deebd184ac881b8179477c2912b0d6a08f051230e05ae19762c64a8e382da55a08555d9e4cadbedbedacf7e6c")!.bytesArray).data(using: .ascii)!

				let encryptedResponse: Data = hexString(fromArray: Data(hexString: "06fc9b6e24000256fd94cb4e2cf9e4d53ad645751c9e64fb479f4e233795a228e445486b546237dd7ad956a90bd66e5d676a856a2cdff8d2fbb1a531620497e53029e563fdf4636e75ad1ab2a7dd47ad48d2fc69f0be396571604f6c1ea7c6f3754c4721c10731db3273884b39529a0ae90397dee0561b9bcfc16936b34b57028f7e265602713ef186f6f23be972cb39d0aa2ad95b94df2f419eb3fff3d546f3c50907dd8bcaa0a06e2f798242cd900a60c9666f5fd31069c8bdd021f36e11c93abfab94711a9a35")!.bytesArray).data(using: .ascii)!

				let decryptedResponse: [String: Any] = ["num_last_4": "1111", "num_bin": "411111", "expiry_month": 12, "expiry_year": 2019, "created_at": 1472137297, "cardholder": ["id": "fmiqs0jp7aibf"], "brand": "visa", "id": "ild7ffjpre3ba"]

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
				let encryptedInvalidResponse: Data = hexString(fromArray: Data(hexString: "06fc9b6e24000256fd94cb4e2cf9e4d53ad645751c9e64fb479f4e233795a228e445486b546237dd7ad956a90bd66e5d676a856a2cdff8d2fbb1a531620497e53029e563fdf4636e75ad1ab2a7dd47ad48d2fc69f0be396571604f6c1ea7c6f3754c4721c10731db3273884b39529a0ae90397dee0561b9bcfc16936b34b57028f7e265602713ef186f6f23be972cb39d0aa2ad95b94df2f419eb3fff3d546f3c50907dd8bcaa0a06e2f798242cd900a60c9666f5fd31069c8bdd021f36e11c93abfab94711a9a35abab1238091230")!.bytesArray).data(using: .ascii)!

				let cryptKey: CryptKey? = try? CryptKey(cryptKeyString: "06fc9b6e24000256b61c6d91d1333932283370ecca62ae6c551745545a1918d0a7c67a58143ee503c850ad861f2d2683052876cf90a64688211b5dd8caef0969dcc887dc5a31e34b")

				it("should throw a correct error") {
					guard let key = cryptKey else { XCTFail("Unexpected key"); return }
					expect { try sut.decrypt(data: encryptedInvalidResponse, key: key) }.to(throwError(StraalCryptor.CryptorError.invalidMessage))
				}
			}

			describe("Invalid key") {
				let encryptedInvalidResponse: Data = hexString(fromArray: Data(hexString: "06fc9b6e24000256fd94cb4e2cf9e4d53ad645751c9e64fb479f4e233795a228e445486b546237dd7ad956a90bd66e5d676a856a2cdff8d2fbb1a531620497e53029e563fdf4636e75ad1ab2a7dd47ad48d2fc69f0be396571604f6c1ea7c6f3754c4721c10731db3273884b39529a0ae90397dee0561b9bcfc16936b34b57028f7e265602713ef186f6f23be972cb39d0aa2ad95b94df2f419eb3fff3d546f3c50907dd8bcaa0a06e2f798242cd900a60c9666f5fd31069c8bdd021f36e11c93abfab94711a9a35")!.bytesArray).data(using: .ascii)!

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
