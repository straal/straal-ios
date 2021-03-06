/*
* CreateCard.swift
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

/// Creates a card
@available(*, deprecated, message: "This operation is deprecated. Use CreateTransactionWithCard.")
public final class CreateCard: EncryptedOperation {

	public typealias Response = EncryptedOperationResponse

	public typealias Context = SimpleOperationContext

	/// Straal card
	public var card: Card

	public internal(set) var context: SimpleOperationContext = .init()

	let permission = CryptKeyPermission.cardsCreate

	public init(card: Card) {
		self.card = card
	}

	func cryptKeyPayload(
		configuration: StraalConfiguration
	) -> CryptKeyPermission {
		permission
	}

	func straalRequestPayload(
		configuration: StraalConfiguration
	) -> Card {
		card
	}

	internal func responseCallable(
		httpCallable: HttpCallable,
		configuration: StraalConfiguration
	) -> AnyCallable<EncryptedOperationResponse> {
		DecodeCallable(
			dataSource: ParseErrorCallable(
				response: httpCallable
			).map { $0.0 }
		).asCallable()
	}
}
