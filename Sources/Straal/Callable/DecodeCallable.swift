/*
 * DecodeCallable.swift
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

class DecodeCallable<T: Decodable>: Callable {
	typealias ReturnType = T
	private let value: AnyCallable<Data>

	init<O: Callable>(dataSource: O) where O.ReturnType == Data {
		self.value = dataSource.asCallable()
	}

	convenience init(data: Data) {
		self.init(dataSource: SimpleCallable.of(data))
	}

	func call() throws -> T {
		try JSONDecoder.default.decode(T.self, from: value.call())
	}
}
