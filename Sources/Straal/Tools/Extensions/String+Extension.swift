/*
 * String+Extension.swift
 * Created by Bartosz Kamiński on 10/07/2017.
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

extension String {

	/**
	Convenience method to retreive a substring of `self`.

	- parameter fromInclusively: The index of the first character that should be included in the substring.
	- parameter toExclusively: The index of the last character that should no longer be included in the substring.

	- returns: Substring starting with the character at index `fromInclusiveley` and ending before the character at index `toExclusively`.
	*/

	subscript(incl fromInclusively: Int, excl toExclusively: Int) -> String? {
		if self.count < toExclusively || fromInclusively >= toExclusively {
			return nil
		}
		return String(self[(self.index(self.startIndex, offsetBy: fromInclusively)..<self.index(self.startIndex, offsetBy: toExclusively))])
	}

	/**
	Convenience computed property to that removes all spaces from a string.
	- returns: String without spaces.
	*/
	var withoutSpaces: String {
		return self.components(separatedBy: CharacterSet.whitespaces).joined()
	}

	/**
	Convenience computed property checking if string consist of only digits.
	- returns: TRUE if digits only in a string, FALSE if otherwise.
	*/
	var isNumeric: Bool {
		let numberCharacters = CharacterSet.decimalDigits.inverted
		return !isEmpty && rangeOfCharacter(from: numberCharacters) == nil
	}
}
