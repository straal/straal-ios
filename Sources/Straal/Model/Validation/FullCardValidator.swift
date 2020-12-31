/*
 * FullCardValidator.swift
 * Created by Bartosz Kamiński on 01/02/2018.
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

/// Validates the card by checking all its properties
final class FullCardValidator: CardValidator {

	private let validators: [CardValidator]

	/**
	Validates the card.
	- parameter card: The payment card.
	- returns: The validation result for all card properties
	*/
	public func validate(card: Card) -> ValidationResult {
		let results = validators.map { $0.validate(card: card) }
		var resultsJoined = results.reduce(ValidationResult(rawValue: 0), { $0.union($1) })
		if !areAllValid(results: results) {
			resultsJoined.remove(.valid)
		}
		return resultsJoined
	}

	/// Initialize full card validator
	public convenience init() {
		self.init(validators: [CardholderNameValidator(), CardNumberValidator(), CVVValidator(), ExpiryValidator()])
	}

	internal init(validators: [CardValidator]) {
		self.validators = validators
	}

	private func areAllValid(results: [ValidationResult]) -> Bool {
		return results.filter { $0.isSuperset(of: .valid) }.count == results.count
	}
}
