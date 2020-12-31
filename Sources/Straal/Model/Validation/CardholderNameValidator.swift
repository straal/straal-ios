/*
 * CardholderNameValidator.swift
 * Created by Hubert Kuczyński on 31.01.2018.
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

/// Validates the cardholder name
public final class CardholderNameValidator: CardValidator {

	/**
	Validates the cardholder name.
	- parameter card: The payment card.
	- returns: The validation result for the cardholder name. Checks if first name and surname are filled and whether their length is greater than or equal to 2
	*/
	public func validate(card: Card) -> ValidationResult {
		let minLength = 5
		let name = card.name
		if name.sanitized.count >= minLength {
			return .valid
		} else {
			return .nameInvalid
		}
	}

	/// Initialize cardholder name validator
	public init() { }
}
