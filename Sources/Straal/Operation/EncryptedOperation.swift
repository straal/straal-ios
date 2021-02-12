/*
 * EncryptedOperation.swift
 * Created by Kajetan Dąbrowski on 24/01/2018.
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

internal protocol EncryptedOperation: StraalOperation {
	var permission: CryptKeyPermission { get }
	associatedtype CryptKeyRequest: Encodable
	associatedtype StraalRequest: Encodable

	func cryptKeyPayload(configuration: StraalConfiguration) -> CryptKeyRequest
	func straalRequestPayload(configuration: StraalConfiguration) -> StraalRequest

	func responseCallable(httpCallable: HttpCallable, configuration: StraalConfiguration) -> AnyCallable<Response>
}

extension EncryptedOperation {
	func cryptKeyData(configuration: StraalConfiguration) -> AnyCallable<Data> {
		EncodeCallable(value: cryptKeyPayload(configuration: configuration)).asCallable()
	}

	func straalRequestData(configuration: StraalConfiguration) -> AnyCallable<Data> {
		EncodeCallable(value: straalRequestPayload(configuration: configuration)).asCallable()
	}
}

extension EncryptedOperation {
	public func perform(configuration: StraalConfiguration) throws -> Response {
		let cryptkeyRequest = HttpCallable(
			requestSource: PostRequestCallable(
				body: cryptKeyData(configuration: configuration),
				url: BackendUrlCreator(configuration: configuration).url(for: .cryptKey),
				headers: configuration.headers),
			configuration: configuration
		)
		let createKey: DecodeCallable<CryptKey> = DecodeCallable(dataSource: ParseErrorCallable(response: cryptkeyRequest).map { $0.0 })
		let encryption = EncryptCallable(
			keySource: createKey,
			messageSource: straalRequestData(configuration: configuration)
		)
		let encryptedRequest = HttpCallable(
			requestSource: PostRequestCallable(
				body: encryption,
				url: StraalUrlCreator(configuration: configuration).url(for: .encrypted),
				headers: configuration.straalDefaultHeaders),
			configuration: configuration
		)

		let operationResponse = responseCallable(httpCallable: encryptedRequest, configuration: configuration)

		return try operationResponse.call()
	}
}
