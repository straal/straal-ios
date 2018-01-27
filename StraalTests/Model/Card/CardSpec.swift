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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

class CardSpec: QuickSpec {
	override func spec() {
		describe("Card") {

			var dateSourceFake: DateSourceFake!

			beforeEach {
				dateSourceFake = DateSourceFake()
				dateSourceFake.currentYear = 2017
				dateSourceFake.currentMonth = 10
			}

			afterEach {
				dateSourceFake = nil
			}

			describe("validation") {

				it("should return correct result when a correct MasterCard card") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
					let result: ValidationResult = [.valid]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a correct MasterCard card with short date") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 20), dateSource: dateSourceFake))
					let result: ValidationResult = [.valid]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a correct MasterCard card with short date in string") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(month: "12", year: "20", dateSource: dateSourceFake))
					let result: ValidationResult = [.valid]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a correct MasterCard card initialied with full cardholder name") {
					let card = Card(name: CardholderName(fullName: "Jan Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
					let result: ValidationResult = [.valid]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a correct MasterCard card but expired") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 9, year: 2017), dateSource: dateSourceFake))
					let result: ValidationResult = [.cardExpired]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when undetermined card type") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "6"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2018), dateSource: dateSourceFake))
					let result: ValidationResult = [.numberDoesNotMatchType]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when not completed Visa card type that is expired") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "4111 5"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2016), dateSource: dateSourceFake))
					let result: ValidationResult = [.numberIncomplete, .cardExpired]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when MasterCard card with a typo in number that is expired") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4443"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2016), dateSource: dateSourceFake))
					let result: ValidationResult = [.luhnTestFailed, .cardExpired]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when AmEx card with incomplete number and incomplete CVV") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "3400 0000 0000"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2018)))
					let result: ValidationResult = [.numberIncomplete, .incompleteCVV]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when MasterCard card too long number and CVV") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 444444"), cvv: CVV(rawValue: "1234"), expiry: Expiry(rawValue: (month: 12, year: 2018), dateSource: dateSourceFake))
					let result: ValidationResult = [.numberTooLong, .invalidCVV]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a card with letters in number") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "abc"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2018), dateSource: dateSourceFake))
					let result: ValidationResult = [.numberDoesNotMatchType, .numberIsNotNumeric]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a card with letters in CVV") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "abs"), expiry: Expiry(rawValue: (month: 12, year: 2018), dateSource: dateSourceFake))
					let result: ValidationResult = [.invalidCVV]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a card with letters in expiry date") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(month: "month", year: "year", dateSource: dateSourceFake))
					let result: ValidationResult = [.invalidExpiry]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a card with empty name") {
					let card = Card(name: CardholderName(firstName: "", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
					let result: ValidationResult = [.invalidName]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result when a card initialized with full name and invalid separator") {
					let card = Card(name: CardholderName(fullName: "Jan/Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
					let result: ValidationResult = [.invalidName]
					expect(card.validation).to(equal(result))
				}

				it("should return correct result name when a card initialized with full name but without surname") {
					let card = Card(name: CardholderName(fullName: "Jan"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
					let result: ValidationResult = [.invalidName]
					expect(card.validation).to(equal(result))
				}
			}

			describe("json") {
				it("should correctly produce card JSON") {
					let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"), number: CardNumber(rawValue: "5555 5555 5555 4444"), cvv: CVV(rawValue: "123"), expiry: Expiry(rawValue: (month: 12, year: 2020), dateSource: dateSourceFake))
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
