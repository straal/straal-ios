/*
 * CVVValidatorSpec.swift
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

			beforeEach {
				sut = CVVValidator()
			}

			afterEach {
				sut = nil
			}

			struct TestCase {
				let number: CardNumber
				let cvv: String
				let expectation: ValidationResult
			}

			let masterCardNumber = CardNumber(rawValue: "5555 5555 5555 4444")
			let americanExpressNumber = CardNumber(rawValue: "3400 0000 0000 009")
			let visaNumber = CardNumber(rawValue: "4111111111111111")

			let testCases: [TestCase] = [
				TestCase(number: masterCardNumber, cvv: "123", expectation: .valid),
				TestCase(number: masterCardNumber, cvv: "034", expectation: .valid),

				TestCase(number: americanExpressNumber, cvv: "1234", expectation: .valid),
				TestCase(number: americanExpressNumber, cvv: "0057", expectation: .valid),

				TestCase(number: visaNumber, cvv: "123", expectation: .valid),
				TestCase(number: visaNumber, cvv: "123", expectation: .valid),

				TestCase(number: masterCardNumber, cvv: "", expectation: .cvvInvalid),
				TestCase(number: masterCardNumber, cvv: "abc", expectation: .cvvInvalid),
				TestCase(number: masterCardNumber, cvv: "12", expectation: .cvvIncomplete),
				TestCase(number: masterCardNumber, cvv: "1234", expectation: .cvvInvalid),
				TestCase(number: americanExpressNumber, cvv: "123", expectation: .cvvIncomplete)
			]

			for testCase in testCases {
				it("should return \(testCase.expectation.description) for CVV \(testCase.cvv)") {
					let card = Card(number: testCase.number, cvv: testCase.cvv)
					expect(sut.validate(card: card)).to(equal(testCase.expectation))
				}
			}
		}
	}
}

private extension Card {
	init(number: CardNumber, cvv: String) {
		self.init(name: CardholderName(firstName: "John", surname: "Appleseed"), number: number, cvv: CVV(rawValue: cvv), expiry: Expiry(month: "04", year: "2020"))
	}
}
