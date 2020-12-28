/*
 * LuhnSpec.swift
 * Created by Kajetan Dąbrowski on 26/09/16.
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

class LuhnSpec: QuickSpec {
	override func spec() {
		describe("Luhn") {
			it("should validate empty correct visa number") {
				expect(Luhn.validate(alphanumericString: "4111111111111111")).to(beTrue())
			}

			it("should not validate incorrect visa number") {
				expect(Luhn.validate(alphanumericString: "4111111111111121")).to(beFalse())
			}

			it("should validate visa as digits") {
				expect(Luhn.validate(digits: [4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])).to(beTrue())
			}

			it("should not validate incorrect visa as digits") {
				expect(Luhn.validate(digits: [4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1])).to(beFalse())
			}

			it("should not validate card as one digit") {
				expect(Luhn.validate(digits: [411111111111])).to(beFalse())
			}

			it("should validate short visa") {
				expect(Luhn.validate(alphanumericString: "4136001231248")).to(beTrue())
			}

			it("should be valid for longer strings") {
				expect(Luhn.validate(alphanumericString: "4111111111111110021")).to(beTrue())
			}
		}
	}
}
