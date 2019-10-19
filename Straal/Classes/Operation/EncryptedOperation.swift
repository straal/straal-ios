/*
 * EncryptedOperation.swift
 * Created by Kajetan Dąbrowski on 24/01/2018.
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

internal protocol EncryptedOperation: StraalOperation {
	var permission: CryptKeyPermission { get }
	var card: Card { get }

	func cryptKeyPayload(configuration: StraalConfiguration) -> AnyCallable<Data>
	var straalRequestPayload: AnyCallable<Data> { get }
	func responseCallable(httpCallable: HttpCallable, configuration: StraalConfiguration) -> AnyCallable<Response>
}

extension EncryptedOperation {
	var straalRequestPayload: AnyCallable<Data> {
		return EncodeCallable(value: card).asCallable()
	}
}

extension EncryptedOperation {
	public func perform(configuration: StraalConfiguration) throws -> Response {
		let cryptkeyRequest = HttpCallable(
			requestSource: PostRequestCallable(
				body: cryptKeyPayload(configuration: configuration),
				url: BackendUrlCreator(configuration: configuration).url(for: .cryptKey),
				headers: configuration.headers)
		)
		let createKey: DecodeCallable<CryptKey> = DecodeCallable(dataSource: ParseErrorCallable(response: cryptkeyRequest).map { $0.0 })
		let encryption = EncryptCallable(
			keySource: createKey,
			messageSource: straalRequestPayload
		)
		let encryptedRequest = HttpCallable(
			requestSource: PostRequestCallable(
				body: encryption,
				url: StraalUrlCreator(configuration: configuration).url(for: .encrypted),
				headers: configuration.straalDefaultHeaders)
		)

		let operationResponse = responseCallable(httpCallable: encryptedRequest, configuration: configuration)

		return try operationResponse.call()
	}
}
