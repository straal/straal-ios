/*
 * CVVValidator.swift
 * Created by Hubert Kuczyński on 30.01.2018.
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

/// Validates the card verification code
public final class CVVValidator: CardValidator {

	/**
	Validates the card verification code.
	- parameter card: The payment card.
	- returns: The validation result for the CVV, taking the current card type into account, as different card issuers can provide CVVs in different formats.
	*/
	public func validate(card: Card) -> ValidationResult {
		guard let brand = CardsParser.cardBrand(for: card.number) else { return .numberDoesNotMatchType }
		if validateNumeric(cvv: card.cvv) == .CVVInvalid {
			return .CVVInvalid
		}
		if card.cvv.length > brand.CVVLength {
			return .CVVInvalid
		} else if card.cvv.length < brand.CVVLength {
			return .CVVIncomplete
		}
		return .valid
	}

	public init() { }

	private func validateNumeric(cvv: CVV) -> ValidationResult {
		return cvv.rawValue.isNumeric ? .valid : .CVVInvalid
	}
}
