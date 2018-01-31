/*
 * CreateCardSpec.swift
 * Created by Kajetan Dąbrowski on 27/01/2018.
 *
 * Straal SDK for iOS
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

@testable import Straal

class CreateCardSpec: QuickSpec {
	override func spec() {

		describe("Create card") {

			var sut: CreateCard!
			var cryptKeyJson: [String: Any] {
				let data: Data = (try? sut.cryptKeyPayload.call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var straalRequestJson: [String: Any] {
				let data: Data = (try? sut.straalRequestPayload.call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			afterEach {
				sut = nil
			}

			beforeEach {
				let card = Card(name: CardholderName(firstName: "John", surname: "Appleseed"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020)))
				sut = CreateCard(card: card)
			}

			describe("Crypt key request json") {
				it("should have correct permission") {
					expect(cryptKeyJson["permission"] as? String).to(equal("v1.cards.create"))
				}
			}

			describe("Straal request json") {
				it("should have correct name") {
					expect(straalRequestJson["name"] as? String).to(equal("John Appleseed"))
				}

				it("should have correct number") {
					expect(straalRequestJson["number"] as? String).to(equal("5555555555554444"))
				}

				it("should have correct cvv") {
					expect(straalRequestJson["cvv"] as? String).to(equal("123"))
				}

				it("should have correct expiry month") {
					expect(straalRequestJson["expiry_month"] as? Int).to(equal(12))
				}

				it("should have correct expiry year") {
					expect(straalRequestJson["expiry_year"] as? Int).to(equal(2020))
				}
			}
		}
	}
}
