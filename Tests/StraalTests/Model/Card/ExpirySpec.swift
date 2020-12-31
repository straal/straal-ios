/*
 * ExpirySpec.swift
 * Created by Bartosz Kamiński on 14/07/2017.
 *
 * Straal SDK for iOS Tests
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

import Foundation
import Quick
import Nimble

@testable import Straal

class ExpirySpec: QuickSpec {
	override func spec() {
		describe("Expiry") {

			describe("initialize") {
				context("with correct string") {

					it("should initialize correctly with preceding zero and full length year") {
						let expiry = Expiry(month: "06", year: "2021")
						expect(expiry.sanitized.month).to(equal(6))
						expect(expiry.sanitized.year).to(equal(2021))
					}

					it("should initialize correct data with month and short year") {
						let expiry = Expiry(month: "6", year: "21")
						expect(expiry.sanitized.month).to(equal(6))
						expect(expiry.sanitized.year).to(equal(2021))
					}
				}

				context("with incorrect string") {

					it("should initialize as incorrect expiry when incorrect month") {
						let expiry = Expiry(month: "invalid", year: "21")
						expect(expiry.sanitized.month).to(equal(Expiry.invalid.rawValue.month))
						expect(expiry.sanitized.year).to(equal(Expiry.invalid.rawValue.year))
					}

					it("should initialize as incorrect expiry when incorrect year") {
						let expiry = Expiry(month: "05", year: "invalid")
						expect(expiry.sanitized.month).to(equal(Expiry.invalid.rawValue.month))
						expect(expiry.sanitized.year).to(equal(Expiry.invalid.rawValue.year))
					}
				}
			}
		}
	}
}
