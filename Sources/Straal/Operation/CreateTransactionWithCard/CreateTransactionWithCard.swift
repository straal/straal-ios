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

	public typealias Context = Init3DSOperationContext // FIXME

	/// Straal card
	public let card: Card

	/// Transaction
	public let transaction: Transaction

	public internal(set) var context: Init3DSOperationContext = .init()

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
				userAgent: ""
			)
		).asCallable()
	}

	internal func responseCallable(
		httpCallable: HttpCallable,
		configuration: StraalConfiguration
	) -> AnyCallable<Encrypted3DSOperationResponse> {
		let cachedRequestResponse = CacheValueCallable(ParseErrorCallable(response: httpCallable))
		let redirectURL = ParseRedirectCallable(response: cachedRequestResponse)

		let operationResponse: DecodeCallable<EncryptedOperationResponse> = DecodeCallable(dataSource: cachedRequestResponse.map { $0.0 })

		let successURL = context.urlProvider.successURL(configuration: configuration)
		let failureURL = context.urlProvider.failureURL(configuration: configuration)

		let threeDSURLs = redirectURL
			.map { ThreeDSURLs(
				redirectURL: $0,
				successURL: successURL,
				failureURL: failureURL
			)
			}

		let showViewController = presentViewControllerFactory(
			threeDSURLs.asCallable(),
			present3DSViewController,
			dismiss3DSViewController,
			SimpleCallable(context.urlOpeningHandler).asCallable()
		)

		let result = operationResponse.merge(showViewController).map { requestAndStatus in
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




public class UserAgent {
	public static let userAgent: String? = {
		guard let info = Bundle.main.infoDictionary,
					let appNameRaw = info["CFBundleDisplayName"] ??  info[kCFBundleIdentifierKey as String],
					let appVersionRaw = info[kCFBundleVersionKey as String],
					let appName = appNameRaw as? String,
					let appVersion = appVersionRaw as? String
		else { return nil }

		#if canImport(UIKit)
		let scale: String
		if #available(iOS 4, *) {
			scale = String(format: "%0.2f", UIScreen.main.scale)
		} else {
			scale = "1.0"
		}

		let model = UIDevice.current.model
		let os = UIDevice.current.systemVersion
		let ua = "\(appName)/\(appVersion) (\(model); iOS \(os); Scale/\(scale))"
		#else
		let ua = "\(appName)/\(appVersion)"
		#endif

		return ua
	}()
}
