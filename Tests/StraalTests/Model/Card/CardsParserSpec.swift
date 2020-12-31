//
/*
 * CardsParserSpec.swift
 * Created by Hubert Kuczyński on 30.01.2018.
 *
 * Straal SDK for iOS
 * Copyright 2020 Straal Sp. z o. o.
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

class CardsParserSpec: QuickSpec {

	override func spec() {
		describe("CardsParser") {

			context("when card brand for number called") {

				struct TestCase {
					let cardNumber: String
					let expectedCardBrand: CardBrand?
				}

				let testCases: [TestCase] = [
					// Invalid
					TestCase(cardNumber: "abc", expectedCardBrand: nil),
					TestCase(cardNumber: "", expectedCardBrand: nil),
					// MasterCard
					TestCase(cardNumber: "5555 5555 5555 4444", expectedCardBrand: MasterCard()),
					TestCase(cardNumber: "5555555555554444", expectedCardBrand: MasterCard()),
					TestCase(cardNumber: "5555-5555-5555-4444", expectedCardBrand: MasterCard()),
					// Visa
					TestCase(cardNumber: "4111 1111 1111 1111", expectedCardBrand: Visa()),
					TestCase(cardNumber: "4111111111111111", expectedCardBrand: Visa()),
					TestCase(cardNumber: "4111-1111-1111-1111", expectedCardBrand: Visa()),
					TestCase(cardNumber: "4532556340774", expectedCardBrand: Visa()),
					// AmericanExpress
					TestCase(cardNumber: "3400 0000 0000 009", expectedCardBrand: AmericanExpress()),
					TestCase(cardNumber: "340000000000009", expectedCardBrand: AmericanExpress()),
					TestCase(cardNumber: "3400-0000-0000-009", expectedCardBrand: AmericanExpress()),
					// Visa Electron
					TestCase(cardNumber: "4917300800000000", expectedCardBrand: VisaElectron()),
					// Switch
					TestCase(cardNumber: "6331101999990016", expectedCardBrand: Switch()),
					// JCB
					TestCase(cardNumber: "3528000700000000", expectedCardBrand: JCB()),
					TestCase(cardNumber: "3566002020360505", expectedCardBrand: JCB()),
					// Diners
					TestCase(cardNumber: "36700102000000", expectedCardBrand: Diners()),
					TestCase(cardNumber: "36148900647913", expectedCardBrand: Diners()),
					// Discover
					TestCase(cardNumber: "6011000400000000", expectedCardBrand: Discover()),
					// CUP
					TestCase(cardNumber: "6255188246115358", expectedCardBrand: CUP()),
					TestCase(cardNumber: "6270183061837567", expectedCardBrand: CUP()),
					// Laser
					TestCase(cardNumber: "630495060000000000", expectedCardBrand: Laser()),
					TestCase(cardNumber: "630490017740292441", expectedCardBrand: Laser()),
					// Dankort
					TestCase(cardNumber: "5019717010103742", expectedCardBrand: Dankort()),
					// Maestro
					TestCase(cardNumber: "5018272349839732", expectedCardBrand: Maestro()),
					TestCase(cardNumber: "5020330598442438", expectedCardBrand: Maestro()),
					// Solo
					TestCase(cardNumber: "6767 6222 2222 2222 222", expectedCardBrand: Solo()),
					TestCase(cardNumber: "6334 9000 0000 0005", expectedCardBrand: Solo()),
					// UATP
					TestCase(cardNumber: "128127188770240", expectedCardBrand: UATP())
				]

				for testCase in testCases {
					it("should return \(String(describing: testCase.expectedCardBrand)) for \(testCase.cardNumber)") {
						let cardNumber = CardNumber(rawValue: testCase.cardNumber)
						if let expectedCardBrand = testCase.expectedCardBrand {
							expect(CardsParser.cardBrand(for: cardNumber)?.isEqual(to: expectedCardBrand)).to(beTrue())
						} else {
							expect(CardsParser.cardBrand(for: cardNumber)).to(beNil())
						}
					}
				}
			}
		}
	}
}
