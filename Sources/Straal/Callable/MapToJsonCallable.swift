/*
 * MapToJsonCallable.swift
 * Created by Kajetan Dąbrowski on 23/01/2018.
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

class MapToJsonCallable: Callable {

	typealias ReturnType = Data
	let source: AnyCallable<[String: Any]>

	init<O: Callable>(source: O) where O.ReturnType == [String: Any] {
		self.source = source.asCallable()
	}

	convenience init(json: [String: Any]) {
		self.init(source: SimpleCallable.of(json))
	}

	func call() throws -> Data {
		return try JSONSerialization.data(withJSONObject: try source.call())
	}
}
