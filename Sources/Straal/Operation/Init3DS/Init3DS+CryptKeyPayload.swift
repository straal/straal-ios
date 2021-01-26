/*
 * Init3DS+CryptKeyPayload.swift
 * Created by Michał Dąbrowski on 26/01/2021.
 *
 * Straal SDK for iOS
 * Copyright 2021 Straal Sp. z o. o.
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

@available(*, deprecated)
extension Init3DSOperation {

	// swiftlint:disable nesting

	struct CryptKeyPayload: Encodable {
		let key: CryptKeyPermission

		let transaction: Transaction
		let successURL: URL
		let failureURL: URL

		func encode(to encoder: Encoder) throws {
			try key.encode(to: encoder)

			var container = encoder.container(keyedBy: CodingKeys.self)

			let superEncoder = container.superEncoder(forKey: .transaction)
			try transaction.encode(to: superEncoder)

			var urlsEncoder = superEncoder.container(keyedBy: URLCodingKeys.self)
			try urlsEncoder.encode(successURL, forKey: .successURL)
			try urlsEncoder.encode(failureURL, forKey: .failureURL)
		}

		enum CodingKeys: String, CodingKey {
			case transaction
		}

		enum URLCodingKeys: String, CodingKey {
			case successURL
			case failureURL
		}
	}

	// swiftlint:enable nesting

}
