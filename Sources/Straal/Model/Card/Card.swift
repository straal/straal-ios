/*
 * Card.swift
 * Created by Bartosz Kamiński on 07/07/2017.
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

/// Represents a card
public struct Card {

	/// Cardholder name and surname
	public let name: CardholderName

	/// Card number
	public let number: CardNumber

	/// Card Verification Value
	public let cvv: CVV

	/// Expiry
	public let expiry: Expiry

	/**
	Creates a new card with the given argument.
	- parameter name: CardholderName struct.
	- parameter number: CardNumber struct.
	- parameter cvv: CVV struct.
	- parameter expiry: Expiry struct.
	*/
	public init(name: CardholderName, number: CardNumber, cvv: CVV, expiry: Expiry) {
		self.name = name
		self.number = number
		self.cvv = cvv
		self.expiry = expiry
	}
}

extension Card: Encodable {

	enum CodingKeys: String, CodingKey {
		case name
		case number
		case cvv
		case expiryMonth
		case expiryYear
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(number, forKey: .number)
		try container.encode(cvv, forKey: .cvv)
		try container.encode(expiry.sanitized.month, forKey: .expiryMonth)
		try container.encode(expiry.sanitized.year, forKey: .expiryYear)
	}
}
