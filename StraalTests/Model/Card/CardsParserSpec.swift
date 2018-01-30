//
/*
 * CardsParserSpec.swift
 * Created by Hubert Kuczyński on 30.01.2018.
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

class CardsParserSpec: QuickSpec {

	private struct CardsParserTestCase {
		let cardNumber: CardNumber
		let expectedCardBrand: CardBrand?
	}

	override func spec() {
		describe("CardsParser") {

			context("when card brand for number called") {

				let testCases: [CardsParserTestCase] = [
					// Invalid
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "123"), expectedCardBrand: nil),
					// MasterCard
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555 5555 5555 4444"), expectedCardBrand: MasterCard()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555555555554444"), expectedCardBrand: MasterCard()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555-5555-5555-4444"), expectedCardBrand: MasterCard()),
					// Visa
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111 1111 1111 1111"), expectedCardBrand: Visa()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111111111111111"), expectedCardBrand: Visa()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111-1111-1111-1111"), expectedCardBrand: Visa()),
					// AmericanExpress
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3400 0000 0000 009"), expectedCardBrand: AmericanExpress()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "340000000000009"), expectedCardBrand: AmericanExpress()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3400-0000-0000-009"), expectedCardBrand: AmericanExpress()),
					// Visa Electron
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4917300800000000"), expectedCardBrand: VisaElectron())

				]

				for testCase in testCases {
					it("should return \(testCase.expectedCardBrand?.name ?? "nil") for \(testCase.cardNumber.rawValue)") {
						if let expectedCardBrand = testCase.expectedCardBrand {
							expect(CardsParser.cardBrand(for: testCase.cardNumber)?.name).to(equal(expectedCardBrand.name))
						} else {
							expect(CardsParser.cardBrand(for: testCase.cardNumber)?.name).to(beNil())
						}
					}
				}
			}
		}
	}
}
