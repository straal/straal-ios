/*
 * CreateTransactionWithCard+CryptKeyPayload.swift
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

extension CreateTransactionWithCard {

	// swiftlint:disable nesting

	struct CryptKeyPayload: Encodable {
		private let key: CryptKeyPermission
		private let transaction: Transaction
		private let authentication3DS: Authentication3DS

		func encode(to encoder: Encoder) throws {
			try key.encode(to: encoder)

			var container = encoder.container(keyedBy: CodingKeys.self)

			let superEncoder = container.superEncoder(forKey: .transaction)
			try transaction.encode(to: superEncoder)

			var authEncoder = superEncoder.container(keyedBy: Authentication3DSCodingKeys.self)
			try authEncoder.encode(authentication3DS, forKey: .authentication3DS)
		}

		enum CodingKeys: String, CodingKey {
			case transaction
		}

		enum Authentication3DSCodingKeys: String, CodingKey {
			case authentication3DS = "authentication_3ds"
		}

		init(
			key: CryptKeyPermission,
			transaction: Transaction,
			successURL: URL,
			failureURL: URL
			) {
			self.key = key
			self.transaction = transaction
			self.authentication3DS = .init(
				successURL: successURL,
				failureURL: failureURL
			)
		}
	}

	private struct Authentication3DS: Encodable {
		var successURL: URL
		var failureURL: URL
	}

	// swiftlint:enable nesting

}
