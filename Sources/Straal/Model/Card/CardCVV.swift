/*
 * CardCVV.swift
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

/// Represents Card Verification Value
public struct CVV: RawRepresentable, Encodable {

	public typealias RawValue = String

	/// CVV number
	public var rawValue: String

	/// The count of digits in the CVV.
	public var length: Int {
		return rawValue.count
	}

	/**
	Creates a new card verification code with the given argument.
	- parameter string: The string representation of the CVV.
	*/
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}
