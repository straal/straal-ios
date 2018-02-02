/*
 * CardBrand.swift
 * Created by Kajetan Dąbrowski on 26/09/2016.
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

//`CardBrand` is a predefined type for different bank cards.
public protocol CardBrand {

	/// The card type name (e.g.: Visa, MasterCard, ...)
	var name: String { get }

	/// The number of digits expected in the Card Verification Value.
	var cvvLength: Int { get }

	/// String used to identify the card type
	var identifyingPattern: String { get }

	/// Bool indicating whether card must be validated using Luhn algorithm
	var luhnValidable: Bool { get }

	/**
	The card number grouping is used to format the card number when typing in the card number text field.
	For Visa Card types for example, this grouping would be [[4,4,4,4]], resulting in a card number format like
	0000-0000-0000-0000.
	- returns: Array of groupings of digits in the card number.
	*/
	var numberGroupings: [[Int]] { get }

	/**
	Returns whether or not `self` is equal to another `CardType`.
	- parameter cardType: Another card type to check equality with.
	- returns: Whether or not `self` is equal to the provided `cardType`.
	*/
	func isEqual(to cardType: CardBrand) -> Bool
}

extension CardBrand {

	/// The count of digits in card number
	public var numberLengths: [Int] {
		return numberGroupings.map { $0.reduce(0) { $0 + $1 }}
	}

	public var luhnValidable: Bool {
		return true
	}

	public var numberGroupings: [[Int]] {
		return [[4, 4, 4, 4]]
	}

	public func isEqual(to cardType: CardBrand) -> Bool {
		return cardType.name == self.name
	}
}
