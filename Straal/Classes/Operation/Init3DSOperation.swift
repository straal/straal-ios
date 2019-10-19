/*
* CreateTransactionWithCard.swift
* Created by Hubert Kuczyński on 12/01/2018.
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

/// Creates a card with the first transaction
public final class Init3DSOperation: EncryptedOperation {
	public typealias Response = Encrypted3DSOperationResponse

	// swiftlint:disable nesting
	private struct PermissionAndTransaction: Encodable {
		let key: CryptKeyPermission

		let transaction: Transaction
		let successURL: URL
		let failureURL: URL

		func encode(to encoder: Encoder) throws {
			try key.encode(to: encoder)

			var container = encoder.container(keyedBy: CodingKeys.self)

			let superEncoder = container.superEncoder(forKey: .transaction)
			try transaction.encode(to: superEncoder)

			var urlsEncoder = superEncoder.container(keyedBy: URLCodingKeys.self.self)
			try urlsEncoder.encode(successURL, forKey: .successURL)
			try urlsEncoder.encode(failureURL, forKey: .failureURL)
		}

		enum CodingKeys: String, CodingKey {
			case transaction
		}

		enum URLCodingKeys: String, CodingKey {
			case successURL = "success_url"
			case failureURL = "failure_url"
		}
	}
	// swiftlint:enable nesting

	func cryptKeyPayload(configuration: StraalConfiguration) -> AnyCallable<Data> {
		return EncodeCallable(
			value: PermissionAndTransaction(
				key: permission,
				transaction: transaction,
				successURL: configuration.init3DSSuccessURL,
				failureURL: configuration.init3DSFailureURL)
			).asCallable()
	}

	/// Straal card
	public let card: Card

	/// Transaction
	public let transaction: Transaction

	private let present3DSViewController: (UIViewController) -> Void

	internal let permission = CryptKeyPermission.authentication3DS

	func responseCallable(httpCallable: HttpCallable, configuration: StraalConfiguration) -> AnyCallable<Encrypted3DSOperationResponse> {
		let cachedRequestResponse = CacheValueCallable(ParseErrorCallable(response: httpCallable))
		let redirectURL = ParseRedirectCallable(response: cachedRequestResponse)

		let operationResponse: DecodeCallable<EncryptedOperationResponse> = DecodeCallable(dataSource: cachedRequestResponse.map { $0.0 })

		let init3DSContext = redirectURL.map { Init3DSContext(redirectURL: $0, successURL: configuration.init3DSSuccessURL, failureURL: configuration.init3DSFailureURL) }

		let showViewController = PresentStraalViewControllerCallable(context: init3DSContext, present: present3DSViewController)

		let result = operationResponse.merge(showViewController).map { requestAndStatus in
			Encrypted3DSOperationResponse(
				requestId: requestAndStatus.0.requestId,
				status: requestAndStatus.1)
		}
		return result.asCallable()
	}

	/// Designated initializer
	public init(card: Card, transaction: Transaction, present3DSViewController: @escaping (UIViewController) -> Void) {
		self.card = card
		self.transaction = transaction
		self.present3DSViewController = present3DSViewController
	}
}
