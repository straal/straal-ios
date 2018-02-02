/*
 * ExpiryValidatorSpec.swift
 * Created by Bartosz Kamiński on 31/01/2018.
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

class ExpiryValidatorSpec: QuickSpec {
	override func spec() {
		describe("ExpiryValidator") {
			var sut: ExpiryValidator!
			var dateSourceFake: DateSourceFake!

			beforeEach {
				dateSourceFake = DateSourceFake()
				dateSourceFake.currentYear = 2018
				dateSourceFake.currentMonth = 1
				sut = ExpiryValidator(dateSource: dateSourceFake)
			}

			afterEach {
				sut = nil
				dateSourceFake = nil
			}

			context("when card with valid date") {

				it("should return valid when expiration date is after current date") {
					let card = Card(expiry: Expiry(rawValue: (month: 10, year: 2020)))
					expect(sut.validate(card: card)).to(equal([.valid]))
				}

				it("should return valid when expiration date is on current year but after current month") {
					let card = Card(expiry: Expiry(rawValue: (month: 5, year: 2018)))
					expect(sut.validate(card: card)).to(equal([.valid]))
				}

				it("should return valid when expiration date is on current month") {
					let card = Card(expiry: Expiry(rawValue: (month: 1, year: 2018)))
					expect(sut.validate(card: card)).to(equal([.valid]))
				}

				it("should return card expired card's expiration date is before current date") {
					let card = Card(expiry: Expiry(rawValue: (month: 1, year: 2017)))
					expect(sut.validate(card: card)).to(equal([.cardExpired]))
				}
			}

			context("when card with invalid date") {

				context("when not in supported range") {

					it("should return card expiry invalid when year is before 2000") {
						let card = Card(expiry: Expiry(rawValue: (month: 1, year: 1999)))
						expect(sut.validate(card: card)).to(equal([.expiryInvalid]))
					}

					it("should return card expiry invalid when year is after 2100") {
						let card = Card(expiry: Expiry(rawValue: (month: 1, year: 2100)))
						expect(sut.validate(card: card)).to(equal([.expiryInvalid]))
					}
				}

				it("should return expiry invalid when invalid month") {
					let card = Card(expiry: Expiry(rawValue: (month: 15, year: 2017)))
					expect(sut.validate(card: card)).to(equal([.expiryInvalid]))
				}

				it("should return card expiry invalid when year is negative") {
					let card = Card(expiry: Expiry(rawValue: (month: 1, year: -5)))
					expect(sut.validate(card: card)).to(equal([.expiryInvalid]))
				}
			}
		}
	}
}

private extension Card {
	init(expiry: Expiry) {
		self.init(name: CardholderName(firstName: "John", surname: "Appleseed"),
				  number: CardNumber(rawValue: "5555555555554444"),
				  cvv: CVV(rawValue: "123"),
				  expiry: expiry)
	}
}
