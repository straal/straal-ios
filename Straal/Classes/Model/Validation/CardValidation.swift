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
		if number.length < numberLength {
			return .numberIncomplete
		} else if number.length > numberLength {
			return .numberTooLong
		} else if !Luhn.validate(alphanumericString: number.sanitized) {
			return .luhnTestFailed
		} else {
			return .valid
		}
	}

	/**
	Validates the card verification code.
	- parameter cvv: The card verification code as indicated on the payment card.
	- returns: The validation result for the CVV, taking the current card type into account, as different card issuers can provide CVVs in different formats.
	*/
	public func validate(cvv: CVV) -> ValidationResult {
		if cvv.validation == .invalidCVV {
			return .invalidCVV
		}
		if cvv.length > CVVLength {
			return .invalidCVV
		} else if cvv.length < CVVLength {
			return .incompleteCVV
		}

		return .valid
	}
}
