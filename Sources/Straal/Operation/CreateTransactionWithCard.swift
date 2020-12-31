/*
* CreateTransactionWithCard.swift
* Created by Hubert Kuczyński on 12/01/2018.
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

/// Creates a card with the first transaction
public final class CreateTransactionWithCard: EncryptedOperation {

	public typealias Response = EncryptedOperationResponse

	// swiftlint:disable nesting
	private struct PermissionAndTransaction: Encodable {
		let key: CryptKeyPermission
		let transaction: Transaction

		func encode(to encoder: Encoder) throws {
			try key.encode(to: encoder)
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(transaction, forKey: .transaction)
		}

		enum CodingKeys: String, CodingKey {
			case transaction
		}
	}
	// swiftlint:enable nesting

	/// Straal card
	public let card: Card

	/// Transaction
	public let transaction: Transaction

	internal let permission = CryptKeyPermission.transactionCardCreate

	func cryptKeyPayload(
		configuration: StraalConfiguration
	) -> AnyCallable<Data> {
		EncodeCallable(value: PermissionAndTransaction(key: permission, transaction: transaction)).asCallable()
	}

	internal func responseCallable(
		httpCallable: HttpCallable,
		configuration: StraalConfiguration
	) -> AnyCallable<EncryptedOperationResponse> {
		DecodeCallable(dataSource: ParseErrorCallable(response: httpCallable).map { $0.0 }).asCallable()
	}

	/// Designated initializer
	public init(card: Card, transaction: Transaction) {
		self.card = card
		self.transaction = transaction
	}
}
