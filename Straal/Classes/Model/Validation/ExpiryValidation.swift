/*
 * ExpiryValidation.swift
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

/// Validates the card expiry date
public final class ExpiryValidator: CardValidator {

	/**
	Validates the card expiry date.
	- parameter card: The payment card.
	- returns: The validation result for the expiry date.
	*/
	func validate(card: Card) -> ValidationResult {
		if !isDateValid(expiry: card.expiry) {
			return .expiryInvalid
		} else if isExpired(expiry: card.expiry) {
			return .cardExpired
		} else {
			return .valid
		}
	}

	/// Initialize expiry validator
	convenience public init() {
		self.init(dateSource: DateSource())
	}

	init(dateSource: DateSourcing) {
		self.dateSource = dateSource
	}

	private let dateSource: DateSourcing

	private func isDateValid(expiry: Expiry) -> Bool {
		let expiry = expiry.sanitized
		return 1...12 ~= expiry.month && 2000..<2100 ~= expiry.year
	}

	private func isExpired(expiry: Expiry) -> Bool {
		let expiry = expiry.sanitized
		if expiry.year == dateSource.currentYear {
			return expiry.month < dateSource.currentMonth
		} else {
			return expiry.year < dateSource.currentYear
		}
	}
}
