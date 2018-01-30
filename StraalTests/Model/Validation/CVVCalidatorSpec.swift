/*
 * CVVCalidatorSpec.swift
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

class CVVValidatorSpec: QuickSpec {
	override func spec() {
		describe("CVVValidator") {

			var sut: CVVValidator!

			let name = CardholderName(firstName: "John", surname: "Appleseed")
			let expiry = Expiry(month: "04", year: "2020")

			let masterCardNumber = CardNumber(rawValue: "5555 5555 5555 4444")
			let americanExpressNumber = CardNumber(rawValue: "3400 0000 0000 009")
			let visaNumber = CardNumber(rawValue: "4111111111111111")

			beforeEach {
				sut = CVVValidator()
			}

			afterEach {
				sut = nil
			}

			describe("Valid") {

				struct CVVTestCase {
					let number: CardNumber
					let cvv: CVV
					let expectation: ValidationResult
				}

				let testCases: [CVVTestCase] = [
					CVVTestCase(number: masterCardNumber, cvv: CVV(rawValue: "123"), expectation: .valid),
					CVVTestCase(number: masterCardNumber, cvv: CVV(rawValue: "034"), expectation: .valid),

					CVVTestCase(number: americanExpressNumber, cvv: CVV(rawValue: "1234"), expectation: .valid),
					CVVTestCase(number: americanExpressNumber, cvv: CVV(rawValue: "0057"), expectation: .valid),

					CVVTestCase(number: visaNumber, cvv: CVV(rawValue: "123"), expectation: .valid),
					CVVTestCase(number: visaNumber, cvv: CVV(rawValue: "123"), expectation: .valid)
				]

				for testCase in testCases {
					it("should return \(testCase.expectation.description) for correct CVV") {
						let card = Card(name: name, number: testCase.number, cvv: testCase.cvv, expiry: expiry)
						expect(sut.validate(card: card)).to(equal(testCase.expectation))
					}
				}
			}

			describe("Invalid") {

				it("should return invalid for empty CVV") {
					let card = Card(name: name, number: masterCardNumber, cvv: CVV(rawValue: ""), expiry: expiry)
					expect(sut.validate(card: card)).to(equal(ValidationResult.CVVInvalid))
				}

				it("should return invalid for non-numeric CVV") {
					let card = Card(name: name, number: masterCardNumber, cvv: CVV(rawValue: "abc"), expiry: expiry)
					expect(sut.validate(card: card)).to(equal(ValidationResult.CVVInvalid))
				}

				it("should return incomplete for too short CVV") {
					let card = Card(name: name, number: masterCardNumber, cvv: CVV(rawValue: "12"), expiry: expiry)
					expect(sut.validate(card: card)).to(equal(ValidationResult.CVVIncomplete))
				}

				it("should return invalid for too long CVV") {
					let card = Card(name: name, number: masterCardNumber, cvv: CVV(rawValue: "1234"), expiry: expiry)
					expect(sut.validate(card: card)).to(equal(ValidationResult.CVVInvalid))
				}
			}
		}
	}
}
