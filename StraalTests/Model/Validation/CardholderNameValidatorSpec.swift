/*
 * CardholderNameValidatorSpec.swift
 * Created by Hubert Kuczyński on 31.01.2018.
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

class CardholderNameValidatorSpec: QuickSpec {
	override func spec() {
		describe("CardholderNameValidator") {

			var sut: CardholderNameValidator!

			beforeEach {
				sut = CardholderNameValidator()
			}

			afterEach {
				sut = nil
			}

			struct TestCase {
				let name: String
				let result: ValidationResult
			}

			let testCases: [TestCase] = [
				TestCase(name: "", result: .nameInvalid),
				TestCase(name: "", result: .nameInvalid),
				TestCase(name: "     ", result: .nameInvalid),
				TestCase(name: "A", result: .nameInvalid),
				TestCase(name: "A A", result: .nameInvalid),
				TestCase(name: "A    A", result: .nameInvalid),
				TestCase(name: "Ab A", result: .nameInvalid),
				TestCase(name: "Ab Ab", result: .valid),
				TestCase(name: "Ab   Ab", result: .valid),
				TestCase(name: "Jan 3 Sobieski", result: .valid)
			]

			for testCase in testCases {
				it("should return \(testCase.result) for CVV \(testCase.name)") {
					let card = Card(name: testCase.name)
					expect(sut.validate(card: card)).to(equal(testCase.result))
				}
			}
		}
	}
}

private extension Card {
	init(name: String) {
		self.init(name: CardholderName(rawValue: name),
				  number: CardNumber(rawValue: "5555 5555 5555 4444"),
				  cvv: CVV(rawValue: "123"),
				  expiry: Expiry(month: "04", year: "2020"))
	}
}
