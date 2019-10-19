/*
* CardNumberValidatorSpec.swift
* Created by Bartosz Kamiński on 01/02/2018.
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble
@testable import Straal

class CardNumberValidatorSpec: QuickSpec {
	override func spec() {
		describe("CardNumberValidator") {
			var sut: CardNumberValidator!

			beforeEach {
				sut = CardNumberValidator()
			}

			afterEach {
				sut = nil
			}

			struct TestCase {
				let description: String
				let number: String
				let expectation: ValidationResult
			}

			let testCases: [TestCase] = [
				TestCase(
					description: "valid Visa card with maximum length",
					number: "4111 1111 1111 1111 110",
					expectation: .valid),
				TestCase(
					description: "Visa pattern but a letter appears",
					number: "4444 44444 4a444 44448",
					expectation: [.numberIsNotNumeric, .luhnTestFailed]),
				TestCase(
					description: "Visa pattern but too short and luhn not passed",
					number: "4444 4444 4444",
					expectation: [.numberIncomplete, .luhnTestFailed]),
				TestCase(
					description: "Visa pattern but too long and luhn not passed",
					number: "4444 4444 4444 4444 4488",
					expectation: [.numberTooLong, .luhnTestFailed]),
				TestCase(
					description: "Visa pattern but too long and with letter at the end",
					number: "4444 4444 4444 4444 448a",
					expectation: [.numberTooLong, .numberIsNotNumeric, .luhnTestFailed]),
				TestCase(
					description: "Visa pattern with maximum allowed length but luhn not passed",
					number: "4444 4444 4444 4444 444",
					expectation: .luhnTestFailed),
				TestCase(
					description: "China Union Pay that doesn't pass luhn (it's not required)",
					number: "6250 9460 0000 0017",
					expectation: [.numberIncomplete, .valid]),
				TestCase(
					description: "Card with invalid pattern",
					number: "0111 1111 1111 1111",
					expectation: .numberDoesNotMatchType),
				TestCase(
					description: "Valid Visa that could be longer",
					number: "4111 1111 1111 9",
					expectation: [.numberIncomplete, .valid]),
				TestCase(
					description: "Invalid Visa because of luhn but might be valid if more digits added",
					number: "4111 1111 1111 14",
					expectation: .numberIncomplete),
				TestCase(
					description: "Valid Amex",
					number: "3457 554476 17674",
					expectation: .valid)
			]

			for testCase in testCases {
				it("should return \(testCase.expectation) for \(testCase.description)") {
					let card = Card(cardNumber: testCase.number)
					expect(sut.validate(card: card)).to(equal(testCase.expectation))
				}
			}
		}
	}
}

private extension Card {
	init(cardNumber: String) {
		self.init(
			name: CardholderName(firstName: "John", surname: "Appleseed"),
			number: CardNumber(rawValue: cardNumber),
			cvv: CVV(rawValue: "123"),
			expiry: Expiry(month: "04", year: "2020"))
	}
}
