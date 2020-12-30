//
/*
 * SimpleCallableSpy.swift
 * Created by Michał Dąbrowski on 18/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2019 Straal Sp. z o. o.
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
@testable import Straal

class CallableSpy<T>: Callable {

	private(set) var callCount: Int = 0
	private let closure: (() throws -> T)

	init(_ closure: @escaping (() throws -> T)) {
		self.closure = closure
	}

	init(_ value: T) {
		closure = { () in value }
	}

	func call() throws -> T {
		callCount += 1
		return try closure()
	}
}
