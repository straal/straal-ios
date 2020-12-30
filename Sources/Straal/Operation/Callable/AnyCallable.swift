/*
 * AnyCallable.swift
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

/// A type-erased `Callable`.
/// Forwards the call to an arbitrary underlying callable with the same `ReturnType`, hiding the specifics of the underlying Callable type.
internal struct AnyCallable<ReturnType>: Callable {

	/// A Type of the call block
	internal typealias CallerType = (() throws -> ReturnType)

	private let caller: CallerType

	/// Construct a collable whose `run()` calls `callable.run()`
	///
	/// - parameter callable: Callable that runs the operation.
	init<O: Callable>(_ callable: O) where O.ReturnType == ReturnType {
		caller = callable.call
	}

	/// Construct AnyCallable instance just passing a method implementation
	///
	/// - Parameter caller: Block of code to call
	init(caller: @escaping CallerType) {
		self.caller = caller
	}

	/// Calls the underlying callable
	///
	/// - Returns: The return value of the callable
	/// - Throws: Error from the callable
	func call() throws -> ReturnType {
		return try caller()
	}

	/// Erases type of callable and returns canonical callable
	///
	/// - Returns: type erased callable
	func asCallable() -> AnyCallable<ReturnType> {
		return self
	}
}

extension Callable {
	/// Erases type of callable and returns canonical callable
	///
	/// - Returns: type erased callable
	func asCallable() -> AnyCallable<ReturnType> {
		return AnyCallable(self)
	}
}
