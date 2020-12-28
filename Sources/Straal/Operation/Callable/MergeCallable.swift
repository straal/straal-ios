//
/*
 * MergeCallable.swift
 * Created by Michał Dąbrowski on 19/10/2019.
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

class MergeCallable<LeftInput, RightInput, ReturnType>: Callable {

	private let lhs: AnyCallable<LeftInput>
	private let rhs: AnyCallable<RightInput>
	private let closure: ((LeftInput, RightInput) throws -> ReturnType)

	init<L: Callable, R: Callable>(_ lhs: L, _ rhs: R, _ closure: @escaping ((LeftInput, RightInput) throws -> ReturnType)) where L.ReturnType == LeftInput, R.ReturnType == RightInput {

		self.lhs = lhs.asCallable()
		self.rhs = rhs.asCallable()
		self.closure = closure
	}

	func call() throws -> ReturnType {
		return try closure(lhs.call(), rhs.call())
	}
}

extension Callable {
	func merge<R: Callable, Result>(_ other: R, _ closure: @escaping((ReturnType, R.ReturnType) throws -> Result)) -> MergeCallable<ReturnType, R.ReturnType, Result> {
		MergeCallable(self, other, closure)
	}

	func merge<R: Callable>(_ other: R) -> MergeCallable<ReturnType, R.ReturnType, (ReturnType, R.ReturnType)> {
		MergeCallable(self, other, { ($0, $1) })
	}
}
