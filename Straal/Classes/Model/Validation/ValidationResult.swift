/*
 * ValidationResult.swift
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
import UIKit

/**
A ValidationResult is an `OptionSetType`. This means, it can be
combined with other ValidationResult. This allows to have multiple
validation results in a single object, like having a card number that
does not match the card type and an expired card at the same time.

**Example:**
````
let result = ValidationResult.NumberDoesNotMatchType.union(ValidationResult.CardExpired)
*/
public struct ValidationResult: OptionSet {
	public let rawValue: UInt16

	public init(rawValue: UInt16) {
		self.rawValue = rawValue
	}

	/// Card is valid
	public static let valid                   = ValidationResult(rawValue: 0)

	/// Card number does not match the specified type or is too long.
	public static let numberDoesNotMatchType  = ValidationResult(rawValue: 1 << 1)

	/// Card number does not match the specified type or is too long.
	public static let numberIsNotNumeric      = ValidationResult(rawValue: 1 << 2)

	/// Card number does match the specified type but is too short.
	public static let numberIncomplete        = ValidationResult(rawValue: 1 << 3)

	/// Indicates that the card number is too long.
	public static let numberTooLong           = ValidationResult(rawValue: 1 << 4)

	/// The Luhn test failed for the credit card number.
	public static let luhnTestFailed          = ValidationResult(rawValue: 1 << 5)

	/// Indicates cardholder name is invalid.
	public static let invalidName             = ValidationResult(rawValue: 1 << 6)

	/// Invalid Card Verificaiton Code.
	public static let invalidCVV              = ValidationResult(rawValue: 1 << 7)

	/// The Card Verification Code is too short.
	public static let incompleteCVV           = ValidationResult(rawValue: 1 << 8)

	/// Indicates that the expiry is invalid
	public static let invalidExpiry           = ValidationResult(rawValue: 1 << 9)

	/// The card has already expired.
	public static let cardExpired             = ValidationResult(rawValue: 1 << 10)
}

extension ValidationResult: CustomStringConvertible {

	/**
	- returns: An array of strings which contain textual descriptions of the validation result in `self`.
	*/
	//swiftlint:disable cyclomatic_complexity
	public func toString() -> [String] {
		var strings: [String] = []

		if self == .valid {							 strings.append("Valid") }
		if isSuperset(of: .numberDoesNotMatchType) { strings.append("Number does not match type") }
		if isSuperset(of: .numberIsNotNumeric) {	 strings.append("Card number is not numeric") }
		if isSuperset(of: .numberIncomplete) {		 strings.append("Card number seems to be incomplete") }
		if isSuperset(of: .numberTooLong) {			 strings.append("Card number is too long") }
		if isSuperset(of: .luhnTestFailed) {		 strings.append("Luhn test failed for card number") }
		if isSuperset(of: .invalidName) {			 strings.append("Name or surname is invalid") }
		if isSuperset(of: .invalidCVV) {			 strings.append("CVV is invalid") }
		if isSuperset(of: .incompleteCVV) {			 strings.append("CVV is too short") }
		if isSuperset(of: .invalidExpiry) {			 strings.append("Expiration date is not valid") }
		if isSuperset(of: .cardExpired) {			 strings.append("Card has expired") }
		return strings
	}
	//swiftlint:enable cyclomatic_complexity

	public var description: String {
		return toString().reduce("") { (current, next) in
			return "\(current)\n\(next)"
		}
	}
}
