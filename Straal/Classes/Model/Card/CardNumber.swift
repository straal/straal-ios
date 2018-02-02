/*
 * CardNumber.swift
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

/// Represents card's number
public struct CardNumber: RawRepresentable {

	public typealias RawValue = String

	/// Credit card number
	public var rawValue: String

	/// Sanitized credit card number without spaces or dashes
	public var sanitized: String {
		return rawValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
	}

	/// The count of digits in card number.
	public var length: Int {
		return sanitized.count
	}

	/**
	Creates a new card number with the given argument.
	- parameter string: The string representation of the card number.
	*/
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

extension CardNumber: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(sanitized)
	}
}
