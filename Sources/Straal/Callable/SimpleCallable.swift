/*
 * SimpleCallable.swift
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

struct SimpleCallable<T>: Callable {
	typealias ReturnType = T
	private let value: (() throws -> T)

	init(_ value: T) {
		self.value = { value }
	}

	init(_ closure: @escaping (() throws -> T)) {
		self.value = closure
	}

	func call() throws -> T {
		return try value()
	}
}

extension Callable {
	static func of(_ value: ReturnType) -> SimpleCallable<ReturnType> {
		return SimpleCallable(value)
	}

	static func just(_ value: ReturnType) -> SimpleCallable<ReturnType> {
		return SimpleCallable(value)
	}
}
