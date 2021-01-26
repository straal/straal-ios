/*
 * IfCallable.swift
 * Created by Michał Dąbrowski on 23/01/2018.
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

struct IfCallable<Condition: Callable, TrueBranch: Callable, FalseBranch: Callable>: Callable where TrueBranch.ReturnType == FalseBranch.ReturnType, Condition.ReturnType == Bool {
	typealias ReturnType = TrueBranch.ReturnType

		private let condition: Condition
		private let trueBranch: TrueBranch
		private let falseBranch: FalseBranch

	init(
		_ condition: Condition,
		_ trueBranch: TrueBranch,
		_ falseBranch: FalseBranch
	) {
		self.condition = condition
		self.trueBranch = trueBranch
		self.falseBranch = falseBranch
	}

	func call() throws -> ReturnType {
		if try condition.call() {
			return try trueBranch.call()
		} else {
			return try falseBranch.call()
		}
	}
}
