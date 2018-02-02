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

			it("should return invalid for too short first name") {
				expect(sut.validate(card: Card(firstName: "a", surname: "Appleseed"))).to(equal(ValidationResult.nameInvalid))
			}

			it("should return invalid for too short surname") {
				expect(sut.validate(card: Card(firstName: "John", surname: "a"))).to(equal(ValidationResult.nameInvalid))
			}

			it("should return invalid for too short first name and surname") {
				expect(sut.validate(card: Card(firstName: "a", surname: ""))).to(equal(ValidationResult.nameInvalid))
			}

			it("should return valid for the correct name") {
				expect(sut.validate(card: Card(firstName: "John", surname: "Appleseed"))).to(equal(ValidationResult.valid))
			}
		}
	}
}

private extension Card {
	init(firstName: String, surname: String) {
		self.init(name: CardholderName(firstName: firstName, surname: surname),
				  number: CardNumber(rawValue: "5555 5555 5555 4444"),
				  cvv: CVV(rawValue: "123"),
				  expiry: Expiry(month: "04", year: "2020"))
	}
}
