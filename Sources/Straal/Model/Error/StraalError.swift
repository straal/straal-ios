/*
 * StraalError.swift
 * Created by Kajetan Dąbrowski on 13/10/2016.
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

public enum StraalError: Swift.Error {

	/// Straal Error domain
	public static let StraalErrorDomain = "StraalErrorDomain"

	/// Unknown error
	case unknown

	/// Unauthorized status
	case unauthorized

	/// Not found
	case notFound

	/// Bad request
	case badRequest

	/// Payment error – your payment couldn't be processed
	case payment

	/// Object was deallocated before the completion block could be called
	case deallocated

	/// Encoding error (internal)
	case encoding

	/// Invalid server response error (internal)
	case invalidResponse
}

extension StraalError: CustomStringConvertible {
	public var description: String {
		switch self {
		case .unknown:
			return "STRAAL ERROR: Unknown error"
		case .unauthorized:
			return "STRAAL ERROR: Unauthorized. The server returned unauthorized status. " +
			"Check your authData."
		case .notFound:
			return "STRAAL ERROR: Endpoint not found. Try checking your routes on your backend."
		case .badRequest:
			return "STRAAL ERROR: Bad request"
		case .payment:
			return "STRAAL ERROR: Your payment could not be processed. " +
			"Credit card invalid, or there was no money on the user's account."
		case .deallocated:
			return "STRAAL CRITICAL ERROR: Straal object was deallocated before it could process your request." +
			"This could lead to inconsistent state."
		case .encoding:
			return "STRAAL ERROR: Could not encode JSON. Please report this."
		case .invalidResponse:
			return "STRAAL ERROR: Invalid Straal response. Please report this."
		}
	}
}
