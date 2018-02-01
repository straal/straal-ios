/*
 * CardholderName.swift
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

public struct CardholderName {

	/// Cardholder's name
	public let firstName: String

	/// Cardholder's surname
	public let surname: String

	/// Carholder's name and surname combined
	public var fullName: String {
		return firstName + " " + surname
	}

	/**
	Creates a new carholder name with the given argument.
	- parameter firstName: Carholder's name.
	- parameter surname: Carholder's surname.
	*/
	public init(firstName: String, surname: String) {
		self.firstName = firstName
		self.surname = surname
	}

	/**
	Creates a new carholder name with the given argument.
	- parameter nameSurname: Carholder's name and surname separated by a space.
	*/
	public init(fullName: String) {
		let components = fullName.components(separatedBy: " ")
		self.firstName = components[safe: 0] ?? ""
		self.surname = components[safe: 1] ?? ""
	}
}

extension CardholderName: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(fullName)
	}
}
