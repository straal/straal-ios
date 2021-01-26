/*
 * EncodeCallable.swift
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

class EncodeCallable<T: Encodable>: Callable {
	typealias ReturnType = Data
	private let value: AnyCallable<T>
	private let keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy

	init<O: Callable>(
		valueSource: O,
		keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
	) where O.ReturnType == T {
		self.keyEncodingStrategy = keyEncodingStrategy
		self.value = valueSource.asCallable()
	}

	convenience init(value: T) {
		self.init(valueSource: SimpleCallable.of(value))
	}

	func call() throws -> Data {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = keyEncodingStrategy
		return try encoder.encode(value.call())
	}
}
