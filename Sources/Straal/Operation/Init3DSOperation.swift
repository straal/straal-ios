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
import UIKit
import SafariServices

/// Creates a card with the first transaction
public final class Init3DSOperation: EncryptedOperation {
	public typealias Response = Encrypted3DSOperationResponse
	public typealias Context = Init3DSOperationContext

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
				successURL: context.urlProvider.successURL(configuration: configuration),
				failureURL: context.urlProvider.failureURL(configuration: configuration))
		).asCallable()
	}

	/// Straal card
	public let card: Card

	/// Transaction
	public let transaction: Transaction

	public internal(set) var context: Init3DSOperationContext = Init3DSOperationContext()

	internal var presentViewControllerFactory: PresentStraalViewControllerFactory = PresentStraalViewControllerCallable.init

	private let present3DSViewController: (UIViewController) -> Void
	private let dismiss3DSViewController: (UIViewController) -> Void

	internal let permission = CryptKeyPermission.authentication3DS

	func responseCallable(httpCallable: HttpCallable, configuration: StraalConfiguration) -> AnyCallable<Encrypted3DSOperationResponse> {
		let cachedRequestResponse = CacheValueCallable(ParseErrorCallable(response: httpCallable))
		let redirectURL = ParseRedirectCallable(response: cachedRequestResponse)

		let operationResponse: DecodeCallable<EncryptedOperationResponse> = DecodeCallable(dataSource: cachedRequestResponse.map { $0.0 })

		let successURL = context.urlProvider.successURL(configuration: configuration)
		let failureURL = context.urlProvider.successURL(configuration: configuration)

		let init3DSURLs = redirectURL
			.map { Init3DSURLs(
				redirectURL: $0,
				successURL: successURL,
				failureURL: failureURL
			)
			}

		let showViewController = presentViewControllerFactory(
			init3DSURLs.asCallable(),
			present3DSViewController,
			dismiss3DSViewController,
			SimpleCallable(context.urlOpeningHandler).asCallable(),
			OpenURLContextParser.init,
			SFSafariViewController.init
		)

		let result = operationResponse.merge(showViewController).map { requestAndStatus in
			Encrypted3DSOperationResponse(
				requestId: requestAndStatus.0.requestId,
				status: requestAndStatus.1)
		}
		return result.asCallable()
	}

	/// Designated initializer. Initializes 3D Secure operation (v1).
	///
	/// - Parameters:
	///   - card: Card to be created and captured
	///   - transaction: Transaction to be authorized with 3D Secure
	///   - present3DSViewController: A closure that Straal will call on the main queue when 3D Secure Authorization will be required. Present passed View Controller to the user
	///   - dismiss3DSViewController: A closure that Straal will call on the main queue when the operation is finished. Do not rely on this closure being called – there are many more ways of dismissing this view controller. This will be called in only some of these cases.
	///
	/// - seealso: [Straal Documentation](https://api-reference.straal.com/#resources-transactions-create-a-3ds-transaction-with-a-card-using-cryptkey)
	public init(
		card: Card,
		transaction: Transaction,
		present3DSViewController: @escaping (UIViewController) -> Void,
		dismiss3DSViewController: @escaping (UIViewController) -> Void) {
		self.card = card
		self.transaction = transaction
		self.present3DSViewController = present3DSViewController
		self.dismiss3DSViewController = dismiss3DSViewController
	}
}
