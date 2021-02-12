/*
 * FlatMapCallable.swift
 * Created by Michał Dąbrowski on 26/01/2021.
 *
 * Straal SDK for iOS
 * Copyright 2021 Straal Sp. z o. o.
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

struct FlatMapCallable<Mapped: Callable, Effect: Callable>: Callable {
	typealias ReturnType = Effect.ReturnType
	private let wrapped: Mapped

	private let closure: ((Mapped.ReturnType) throws -> Effect)

	init(_ wrapped: Mapped, closure: @escaping ((Mapped.ReturnType) throws -> Effect)) {
		self.wrapped = wrapped
		self.closure = closure
	}

	func call() throws -> Effect.ReturnType {
		return try closure(try wrapped.call()).call()
	}
}

extension Callable {
	func flatMap<Effect: Callable>(_ closure: @escaping((ReturnType) throws -> Effect)) -> FlatMapCallable<Self, Effect> {
		FlatMapCallable(self, closure: closure)
	}
}
