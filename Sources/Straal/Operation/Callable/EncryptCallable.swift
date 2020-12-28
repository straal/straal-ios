/*
 * EncryptCallable.swift
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

internal class EncryptCallable: Callable {
	typealias ReturnType = Data

	private let keySource: AnyCallable<CryptKey>
	private let messageSource: AnyCallable<Data>

	init<K: Callable, M: Callable>(keySource: K, messageSource: M) where K.ReturnType == CryptKey, M.ReturnType == Data {
		self.keySource = keySource.asCallable()
		self.messageSource = messageSource.asCallable()
	}

	func call() throws -> Data {
		return try StraalCryptor().encrypt(data: messageSource.call(), key: keySource.call())
	}
}
