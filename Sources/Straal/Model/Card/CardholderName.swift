/*
 * CardholderName.swift
 * Created by Bartosz Kamiński on 11/07/2017.
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

/// Represents cardholder's name
public struct CardholderName: RawRepresentable {

	public typealias RawValue = String

	/// Cardholder's name
	public let rawValue: String

	/// Sanitized cardholder name without unsupported characters
	public var sanitized: String {
		let components = rawValue.components(separatedBy: .whitespacesAndNewlines)
		return components.filter { !$0.isEmpty }.joined(separator: " ")
	}

	/**
	Creates a new carholder name with the given argument.
	- parameter nameSurname: Carholder's name and surname separated by a space.
	*/
	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	/**
	Creates a new carholder name with the given argument.
	- parameter firstName: Carholder's name.
	- parameter surname: Carholder's surname.
	*/
	public init(firstName: String, surname: String) {
		self.rawValue = firstName + " " + surname
	}
}

extension CardholderName: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(sanitized)
	}
}
