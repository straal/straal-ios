//
/*
 * MapCallable.swift
 * Created by Michał Dąbrowski on 18/10/2019.
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

class MapCallable<InputType, ReturnType>: Callable {

	private let wrapped: AnyCallable<InputType>
	private let closure: ((InputType) throws -> ReturnType)

	init<O: Callable>(_ wrapped: O, _ closure: @escaping ((InputType) throws -> ReturnType)) where O.ReturnType == InputType {
		self.wrapped = wrapped.asCallable()
		self.closure = closure
	}

	func call() throws -> ReturnType {
		return try closure(try wrapped.call())
	}
}

extension Callable {
	func map<T>(_ closure: @escaping((ReturnType) throws -> T)) -> MapCallable<ReturnType, T> {
		MapCallable(self, closure)
	}
}
