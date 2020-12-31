/*
 * Expiry.swift
 * Created by Bartosz Kamiński on 07/07/2017.
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

/// Represents card's expiry date
public struct Expiry: RawRepresentable {
	public typealias RawValue = (month: Int, year: Int)

	/// The month and year of the expiration date.
	public let rawValue: (month: Int, year: Int)

	/// The month and year of the expiration date with corrected year
	public var sanitized: (month: Int, year: Int) {
		if rawValue == Expiry.invalid.rawValue {
			return rawValue
		}
		let yearCorrected: Int = {
			if 0...99 ~= rawValue.year {
				return rawValue.year + 2000
			}
			return rawValue.year
		}()
		return (month: rawValue.month, year: yearCorrected)
	}

	/// An invalid expiry date
	internal static let invalid = Expiry(rawValue: (month: 0, year: 0))

	/**
	Creates a CardExpiry with the given month and year as Ints.
	- parameter month:     The month number (of numeric format MM).
	- parameter year:      The year number (of numeric format YY or YYYY).
	*/
	public init(rawValue: (month: Int, year: Int)) {
		self.rawValue = rawValue
	}

	/**
	Creates a CardExpiry with the given month and year as String.
	- parameter month:     The month string (of numeric format MM).
	- parameter year:      The year string (of numeric format YY or YYYY).
	*/
	public init(month: String, year: String) {
		guard let monthNumber = Int(month),
			  let yearNumber = Int(year)
		else {
			self.init(rawValue: Expiry.invalid.rawValue)
			return
		}
		self.init(rawValue: (month: monthNumber, year: yearNumber))
	}
}
