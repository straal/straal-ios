/*
 * EncryptedOperationResponse.swift
 * Created by Kajetan Dąbrowski on 23/01/2018.
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

public struct Operation3DSContext {
	public let redirectURL: URL
	public let successURL: URL
	public let failureURL: URL
}

public struct Encrypted3DSOperationResponse: StraalResponse {
	public let requestId: String
	public let operation3DSContext: Operation3DSContext

	internal init(requestId: String, context: Operation3DSContext) {
		self.requestId = requestId
		self.operation3DSContext = context
	}
}

extension Encrypted3DSOperationResponse: CustomDebugStringConvertible {
	public var debugDescription: String {
		return "STRAAL 3DS REQUEST [\(requestId)]"
	}
}
