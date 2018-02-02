//
/*
 * FullCardValidatorSpec.swift
 * Created by Hubert Kuczyński on 02.02.2018.
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

class FullCardValidatorSpec: QuickSpec {
	override func spec() {
		describe("Full card validator") {

			var sut: FullCardValidator!
			var cardValidatorFakes: [CardValidatorFake]!

			beforeEach {
				cardValidatorFakes = [CardValidatorFake(), CardValidatorFake()]
				sut = FullCardValidator(validators: cardValidatorFakes)
			}

			afterEach {
				sut = nil
				cardValidatorFakes = nil
			}

			struct CardValidatorTestCase {
				let inputResults: [ValidationResult]
				let expectedResult: ValidationResult
			}

			let card = Card(name: CardholderName(firstName: "Jan", surname: "Kowalski"),
							number: CardNumber(rawValue: "5555 5555 5555 4444"),
							cvv: CVV(rawValue: "123"),
							expiry: Expiry(month: "12", year: "2020"))

			let testCases: [CardValidatorTestCase] = [
				CardValidatorTestCase(inputResults: [.cvvInvalid, .valid], expectedResult: .cvvInvalid),
				CardValidatorTestCase(inputResults: [[.valid, .numberIncomplete], .valid], expectedResult: [.valid, .numberIncomplete]),
				CardValidatorTestCase(inputResults: [.valid, .numberIncomplete], expectedResult: .numberIncomplete),
				CardValidatorTestCase(inputResults: [.cardExpired, .valid], expectedResult: .cardExpired),
				CardValidatorTestCase(inputResults: [.cardExpired, .numberTooLong], expectedResult: [.cardExpired, .numberTooLong]),
				CardValidatorTestCase(inputResults: [.valid, .valid], expectedResult: .valid),
				CardValidatorTestCase(inputResults: [.expiryInvalid, .valid], expectedResult: .expiryInvalid),
				CardValidatorTestCase(inputResults: [.luhnTestFailed, .valid], expectedResult: .luhnTestFailed),
				CardValidatorTestCase(inputResults: [.numberIsNotNumeric, .valid], expectedResult: .numberIsNotNumeric),
				CardValidatorTestCase(inputResults: [.numberDoesNotMatchType, .valid], expectedResult: .numberDoesNotMatchType),
				CardValidatorTestCase(inputResults: [.cvvIncomplete, .numberIncomplete], expectedResult: [.cvvIncomplete, .numberIncomplete])
			]

			for testCase in testCases {
				it("should return correct result when a correct MasterCard card") {
					cardValidatorFakes[0].validationResultToReturn = testCase.inputResults[0]
					cardValidatorFakes[1].validationResultToReturn = testCase.inputResults[1]
					expect(sut.validate(card: card)).to(equal(testCase.expectedResult))
				}
			}
		}
	}
}
