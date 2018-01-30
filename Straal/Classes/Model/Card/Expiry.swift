/*
 * Expiry.swift
 * Created by Bartosz Kamiński on 07/07/2017.
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

/**
A Credit Card Expiry date.
*/
public struct Expiry: RawRepresentable, Validating {
	public typealias RawValue = (month: Int, year: Int)

	/// The month and year of the expiration date.
	public let rawValue: (month: Int, year: Int)

	/// The month and year of the expiration date with corrected year
	public var sanitized: (month: Int, year: Int) {
		let yearCorrected: Int = {
			if 0...99 ~= rawValue.year {
				return rawValue.year + 2000
			}
			return rawValue.year
		}()
		return (month: rawValue.month, year: yearCorrected)
	}

	/// Validation property: checks date is valid and if card is expired
	public var validation: ValidationResult {
		if !isValidDate {
			return .expiryInvalid
		} else if expired {
			return .cardExpired
		} else {
			return []
		}
	}

	/// An invalid expiry date
	internal static let invalid = Expiry(rawValue: (month: 0, year: 0))

	private static var dateSource: DateSourcing = DateSource()

	/**
	Creates a CardExpiry with the given month and year as Ints.
	- parameter month:     The month number (of numeric format MM).
	- parameter year:      The year number (of numeric format YY or YYYY).
	*/
	public init(rawValue: (month: Int, year: Int)) {
		self.init(rawValue: rawValue, dateSource: DateSource())
	}

	internal init(rawValue: (month: Int, year: Int), dateSource: DateSourcing) {
		self.rawValue = rawValue
		Expiry.dateSource = dateSource
	}

	/**
	Creates a CardExpiry with the given month and year as String.
	- parameter month:     The month string (of numeric format MM).
	- parameter year:      The year string (of numeric format YY or YYYY).
	*/
	public init(month: String, year: String) {
		guard let monthNumber = Int(month),
			let yearNumber = Int(year),
			year.count >= 2,
			year.count <= 4 else {
				self.init(rawValue: Expiry.invalid.rawValue)
				return
		}

		self.init(rawValue: (month: monthNumber, year: yearNumber))
	}

	internal init(month: String, year: String, dateSource: DateSourcing) {
		self.init(month: month, year: year)
		Expiry.dateSource = dateSource
	}

	/// Validation property: checks if expiration date is a valid date
	private var isValidDate: Bool {
		if (1...12).contains(sanitized.month) && sanitized.year >= 2000 {
			return true
		} else {
			return false
		}
	}

	/// Validation property: checks if expiration date is expired
	private var expired: Bool {
		let dateSource = Expiry.dateSource
		if sanitized.year == dateSource.currentYear {
			return sanitized.month >= dateSource.currentMonth ? false : true
		} else if sanitized.year > dateSource.currentYear {
			return false
		} else {
			return true
		}
	}

}
