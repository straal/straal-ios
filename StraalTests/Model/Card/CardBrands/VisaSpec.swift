/*
 * VisaSpec.swift
 * Created by Bartosz Kamiński on 11/07/2017.
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

class VisaSpec: QuickSpec {
	override func spec() {
		describe("Visa") {

			var sut: Visa!

			beforeEach {
				sut = Visa()
			}

			afterEach {
				sut = nil
			}

			describe("Number validation") {

				it("should return valid for correct Visa card number") {
					expect(sut.validate(number: CardNumber(rawValue: "4111 1111 1111 1111"))).to(equal(ValidationResult.valid))
					expect(sut.validate(number: CardNumber(rawValue: "4111111111111111"))).to(equal(ValidationResult.valid))
					expect(sut.validate(number: CardNumber(rawValue: "4111-1111-1111-1111"))).to(equal(ValidationResult.valid))
				}

				it("should return number not numeric for empty number") {
					expect(sut.validate(number: CardNumber(rawValue: ""))).to(equal(ValidationResult.numberIsNotNumeric))
				}

				it("should return number not numeric for non-numeric number") {
					expect(sut.validate(number: CardNumber(rawValue: "abc"))).to(equal(ValidationResult.numberIsNotNumeric))
				}

				it("should return incomplete for incomplete number") {
					expect(sut.validate(number: CardNumber(rawValue: "4111 1111"))).to(equal(ValidationResult.numberIncomplete))
				}

				it("should return too long for too long number") {
					expect(sut.validate(number: CardNumber(rawValue: "4111 1111 1111 111111111"))).to(equal(ValidationResult.numberTooLong))
				}

				it("should return luhn test failed for incorrect number") {
					expect(sut.validate(number: CardNumber(rawValue: "4111 1111 1111 1112"))).to(equal(ValidationResult.luhnTestFailed))
				}
			}
		}
	}
}
