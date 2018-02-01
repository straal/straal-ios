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
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "abc"), expectedCardBrand: nil),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: ""), expectedCardBrand: nil),
					// MasterCard
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555 5555 5555 4444"), expectedCardBrand: MasterCard()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555555555554444"), expectedCardBrand: MasterCard()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5555-5555-5555-4444"), expectedCardBrand: MasterCard()),
					// Visa
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111 1111 1111 1111"), expectedCardBrand: Visa()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111111111111111"), expectedCardBrand: Visa()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4111-1111-1111-1111"), expectedCardBrand: Visa()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4532556340774"), expectedCardBrand: Visa()),
					// AmericanExpress
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3400 0000 0000 009"), expectedCardBrand: AmericanExpress()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "340000000000009"), expectedCardBrand: AmericanExpress()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3400-0000-0000-009"), expectedCardBrand: AmericanExpress()),
					// Visa Electron
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "4917300800000000"), expectedCardBrand: VisaElectron()),
					// Switch
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6331101999990016"), expectedCardBrand: Switch()),
					// JCB
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3528000700000000"), expectedCardBrand: JCB()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "3566002020360505"), expectedCardBrand: JCB()),
					// Diners
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "36700102000000"), expectedCardBrand: Diners()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "36148900647913"), expectedCardBrand: Diners()),
					// Discover
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6011000400000000"), expectedCardBrand: Discover()),
					// CUP
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6255188246115358"), expectedCardBrand: CUP()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6270183061837567"), expectedCardBrand: CUP()),
					// Laser
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "630495060000000000"), expectedCardBrand: Laser()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "630490017740292441"), expectedCardBrand: Laser()),
					// Dankort
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5019717010103742"), expectedCardBrand: Dankort()),
					// Maestro
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5018272349839732"), expectedCardBrand: Maestro()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "5020330598442438"), expectedCardBrand: Maestro()),
					// Solo
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6767 6222 2222 2222 222"), expectedCardBrand: Solo()),
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "6334 9000 0000 0005"), expectedCardBrand: Solo()),
					// UATP
					CardsParserTestCase(cardNumber: CardNumber(rawValue: "128127188770240"), expectedCardBrand: UATP())
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
