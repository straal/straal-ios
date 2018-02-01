/*
 * CardValidation.swift
 * Created by Bartosz Kamiński on 11/07/2017.
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

extension CardBrand {

	/**
	Validates the card number.
	- parameter number: The card number.
	- returns: The result of the card number validation.
	*/
	public func validate(number: CardNumber) -> ValidationResult {
		if number.validation == .numberIsNotNumeric {
			return .numberIsNotNumeric
		}
		if number.length < numberLengths.min() ?? 0 {
			return .numberIncomplete
		} else if number.length > numberLengths.max() ?? 0 {
			return .numberTooLong
		} else if !Luhn.validate(alphanumericString: number.sanitized) {
			return .luhnTestFailed
		} else {
			return .valid
		}
	}
}
