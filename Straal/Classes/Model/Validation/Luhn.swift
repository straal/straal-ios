/*
 * Luhn.swift
 * Created by Kajetan Dąbrowski on 26/09/2016.
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

class Luhn {
	class func validate(alphanumericString: String) -> Bool {
		guard let digitsView = digits(fromString: alphanumericString) else { return false }
		return validate(digits: digitsView)
	}

	class func validate(digits: [Int]) -> Bool {
		var odd: Bool = true
		var sum: Int = 0
		for var digit in digits.reversed() {
			odd = !odd
			if odd { digit *= 2 }
			if digit > 9 { digit -= 9 }
			sum += digit
		}
		return sum % 10 == 0
	}

	private class func digits(fromString string: String) -> [Int]? {
		let parsedDigits: [Int?] = string.map {
			return Int(String($0))
		}
		for digit in parsedDigits {
			if digit == nil || digit! < 0 || digit! > 9 { return nil }
		}
		return parsedDigits.map { return $0! }
	}
}
