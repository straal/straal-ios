/*
* CardNumberValidator.swift
* Created by Bartosz Kamiński on 01/02/2018.
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

/// Validates the card number
public final class CardNumberValidator: CardValidator {

	/**
	Validates the card number.
	- parameter card: The payment card.
	- returns: The validation result for the number, taking the card type into account, as card issuers have different card number length or format.
	*/
	public func validate(card: Card) -> ValidationResult {
		let number = card.number
		var result: ValidationResult = []
		if !number.sanitized.isNumeric {
			result.insert(.numberIsNotNumeric )
		}
		guard let brand = CardsParser.cardBrand(for: number) else {
			result.insert(.numberDoesNotMatchType)
			return result
		}
		let maximumNumberLength = brand.numberLengths.max()!
		if number.length < maximumNumberLength {
			result.insert(.numberIncomplete)
		} else if number.length > maximumNumberLength {
			result.insert(.numberTooLong)
		}
		if brand.luhnValidable && !Luhn.validate(alphanumericString: number.sanitized) {
			result.insert(.luhnTestFailed)
		}
		if isValid(result: result) || isIncompleteButValid(result: result, validNumberLengths: brand.numberLengths, numberLength: number.length) {
			result.insert(.valid)
		}
		return result
	}

	private func isValid(result: ValidationResult) -> Bool {
		return result.isEmpty
	}

	private func isIncompleteButValid(result: ValidationResult, validNumberLengths: [Int], numberLength: Int) -> Bool {
		return result == .numberIncomplete && validNumberLengths.contains(numberLength)
	}

	/// Initialize card number validator
	public init() { }
}
