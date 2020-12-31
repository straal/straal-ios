/*
 * CardholderNameSpec.swift
 * Created by Bartosz Kamiński on 02/02/2018.
 *
 * Straal SDK for iOS
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

class CardholderNameSpec: QuickSpec {
	override func spec() {
		describe("CardholderName") {

			describe("sanitization") {

				context("when initialized with full name") {

					struct TestCase {
						let fullName: String
						let sanitized: String
					}

					let testCases: [TestCase] = [
						TestCase(fullName: "", sanitized: ""),
						TestCase(fullName: "  ", sanitized: ""),
						TestCase(fullName: "Ab Cd", sanitized: "Ab Cd"),
						TestCase(fullName: "Ab\tCd", sanitized: "Ab Cd"),
						TestCase(fullName: "Ab\nCd", sanitized: "Ab Cd"),
						TestCase(fullName: "Greg O'Hare", sanitized: "Greg O'Hare"),
						TestCase(fullName: "Margarita Tequila-Tortilla", sanitized: "Margarita Tequila-Tortilla"),
						TestCase(fullName: " Ab Cd  ", sanitized: "Ab Cd"),
						TestCase(fullName: " 電电電 ", sanitized: "電电電"),
						TestCase(fullName: "Ab     Cd", sanitized: "Ab Cd"),
						TestCase(fullName: "  Ab     Cd   ", sanitized: "Ab Cd"),
						TestCase(fullName: "Ab Cd C", sanitized: "Ab Cd C")
					]

					for testCase in testCases {
						it("should return \(testCase.sanitized) when asked for a sanitized \(testCase.fullName)") {
							expect(CardholderName(rawValue: testCase.fullName).sanitized).to(equal(testCase.sanitized))
						}
					}
				}

				context("when initialized with name and surname") {

					struct TestCase {
						let name: String
						let surname: String
						let sanitized: String
					}

					let testCases: [TestCase] = [
						TestCase(name: "", surname: "B", sanitized: "B"),
						TestCase(name: "Ab", surname: "Cd", sanitized: "Ab Cd"),
						TestCase(name: "電电", surname: "電电", sanitized: "電电 電电"),
						TestCase(name: "Ab Cd", surname: "Ef", sanitized: "Ab Cd Ef"),
						TestCase(name: "J.", surname: "Gonzales", sanitized: "J. Gonzales"),
						TestCase(name: "Ab   Cd  ", surname: "Ef", sanitized: "Ab Cd Ef"),
						TestCase(name: "   Ab   ", surname: "  Cd   ", sanitized: "Ab Cd")
					]

					for testCase in testCases {
						it("should return \(testCase.sanitized) when asked for a sanitized \(testCase.name) and \(testCase.surname)") {
							expect(CardholderName(firstName: testCase.name, surname: testCase.surname).sanitized).to(equal(testCase.sanitized))
						}
					}
				}
			}
		}
	}
}
