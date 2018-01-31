/*
 * CardSpec.swift
 * Created by Bartosz Kamiński on 14/07/2017.
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

@testable import Straal

class CardSpec: QuickSpec {
	override func spec() {
		describe("Card") {

			describe("encode to JSON") {
				it("should encode correctly") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020)))
					guard let json = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(card)) as? [String: Any] else { XCTFail("Unexpected JSON"); return }
					expect(json?["name"] as? String).to(equal("Jan Kowalski"))
					expect(json?["number"] as? String).to(equal("5555555555554444"))
					expect(json?["cvv"] as? String).to(equal("123"))
					expect(json?["expiry_month"] as? Int).to(equal(12))
					expect(json?["expiry_year"] as? Int).to(equal(2020))
				}
			}
		}
	}
}
