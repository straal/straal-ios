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

/// Creates a card with the first transaction
public final class CreateTransactionWithCard: EncryptedOperation {

	public typealias Response = Encrypted3DSOperationResponse

	public typealias Context = ThreeDSOperationContext

	/// Straal card
	public let card: Card

	/// Transaction
	public let transaction: Transaction

	public internal(set) var context: ThreeDSOperationContext = .init()

	internal var presentViewControllerFactory: PresentStraalViewControllerFactory = PresentStraalViewControllerCallable.init

	private let present3DSViewController: (UIViewController) -> Void
	private let dismiss3DSViewController: (UIViewController) -> Void

	internal let permission = CryptKeyPermission.transactionCardCreate

	func cryptKeyPayload(
		configuration: StraalConfiguration
	) -> AnyCallable<Data> {
		let successURL = context.urlProvider.successURL(configuration: configuration)
		let failureURL = context.urlProvider.failureURL(configuration: configuration)
		let language = configuration.locale.identifier
		return EncodeCallable(
			value: CryptKeyPayload(
				key: permission,
				transaction: transaction,
				successURL: successURL,
				failureURL: failureURL,
				language: language,
				userAgent: configuration.userAgent.userAgent
			)
		).asCallable()
	}

	internal func responseCallable(
		httpCallable: HttpCallable,
		configuration: StraalConfiguration
	) -> AnyCallable<Encrypted3DSOperationResponse> {
		let cachedRequestResponse = CacheValueCallable(ParseErrorCallable(response: httpCallable))
		let redirectURL = ParseRedirectCallable(response: cachedRequestResponse)
		let catchCallable = CatchCallable(redirectURL.map { $0 }, default: nil)
		let cachedURL = CacheValueCallable<URL?>(catchCallable)
		let operationResponse: DecodeCallable<EncryptedOperationResponse> = DecodeCallable(dataSource: cachedRequestResponse.map { $0.0 })

		let resultCallable = IfCallable(
			cachedURL.map { $0 != nil },
			cachedURL.map { [context] in
				ThreeDSURLs(
					redirectURL: $0!,
					successURL: context.urlProvider.successURL(configuration: configuration),
					failureURL: context.urlProvider.failureURL(configuration: configuration)
				)
			}
			.flatMap { [context, presentViewControllerFactory, present3DSViewController, dismiss3DSViewController] urls in
				presentViewControllerFactory(
					SimpleCallable.just(urls).asCallable(),
					present3DSViewController,
					dismiss3DSViewController,
					SimpleCallable(context.urlOpeningHandler).asCallable()
				)
			},
			SimpleCallable.just(Encrypted3DSOperationStatus.success)
		)

		let result = operationResponse.merge(resultCallable).map { requestAndStatus in
			Encrypted3DSOperationResponse(
				requestId: requestAndStatus.0.requestId,
				status: requestAndStatus.1)
		}
		return result.asCallable()
	}

	/// Designated initializer
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
