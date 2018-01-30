/*
 * ExpirySpec.swift
 * Created by Bartosz Kamiński on 14/07/2017.
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

class ExpirySpec: QuickSpec {
	override func spec() {
		describe("Expiry") {

			var dateSourceFake: DateSourceFake!

			beforeEach {
				dateSourceFake = DateSourceFake()
				dateSourceFake.currentYear = 2020
				dateSourceFake.currentMonth = 10
			}

			afterEach {
				dateSourceFake = nil
			}

			describe("create") {

				context("when passed correct data with month with preceding zero and full length year") {

					var expiry: Expiry!

					beforeEach {
						expiry = Expiry(month: "06", year: "2021", dateSource: dateSourceFake)
					}

					afterEach {
						expiry = nil
					}

					it("should have correct data") {
						expect(expiry.sanitized.month).to(equal(6))
						expect(expiry.sanitized.year).to(equal(2021))
					}

					it("should validate correctly") {
						expect(expiry.validation).to(equal([]))
					}
				}

				context("when passed correct data with month and short year") {

					var expiry: Expiry!

					beforeEach {
						expiry = Expiry(month: "6", year: "21", dateSource: dateSourceFake)
					}

					afterEach {
						expiry = nil
					}

					it("should have correct data") {
						expect(expiry.sanitized.month).to(equal(6))
						expect(expiry.sanitized.year).to(equal(2021))
					}

					it("should validate correctly") {
						expect(expiry.validation).to(equal([]))
					}
				}

				context("when passed incorrect string") {

					it("should validate with invalid date") {
						let result: ValidationResult = [.expiryInvalid]
						expect(Expiry(month: "", year: "", dateSource: dateSourceFake).validation).to(equal(result))
						expect(Expiry(month: "abc", year: "def", dateSource: dateSourceFake).validation).to(equal(result))
					}
				}

				context("when passed correct string with incorrect date") {

					it("should validate with invalid date") {
						let result: ValidationResult = [.expiryInvalid]
						expect(Expiry(month: "13", year: "2012", dateSource: dateSourceFake).validation).to(equal(result))
						expect(Expiry(month: "-1", year: "30", dateSource: dateSourceFake).validation).to(equal(result))
						expect(Expiry(month: "12", year: "1999", dateSource: dateSourceFake).validation).to(equal(result))
					}
				}
			}

			describe("expiry") {

				it("should return expired") {
					let result: ValidationResult = [.cardExpired]
					expect(Expiry(month: "5", year: "2019", dateSource: dateSourceFake).validation).to(equal(result))
					expect(Expiry(month: "9", year: "2020", dateSource: dateSourceFake).validation).to(equal(result))
				}

				it("should validate correctly") {
					let result: ValidationResult = []
					expect(Expiry(month: "1", year: "2021", dateSource: dateSourceFake).validation).to(equal(result))
					expect(Expiry(month: "12", year: "2020", dateSource: dateSourceFake).validation).to(equal(result))
					expect(Expiry(month: "10", year: "2020", dateSource: dateSourceFake).validation).to(equal(result))
				}
			}
		}
	}
}
