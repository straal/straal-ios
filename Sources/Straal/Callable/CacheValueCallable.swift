//
/*
 * CacheValueCallable.swift
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

class CacheValueCallable<ReturnType>: Callable {

	private let wrapped: AnyCallable<ReturnType>
	private var cached: ReturnType?

	init<O: Callable>(_ wrapped: O) where O.ReturnType == ReturnType {
		self.wrapped = wrapped.asCallable()
	}

	func call() throws -> ReturnType {
		objc_sync_enter(self)
		defer { objc_sync_exit(self) }
		if let cached = cached { return cached }
		let cached = try wrapped.call()
		self.cached = cached
		return cached
	}

}

extension Callable {
	func cached() -> CacheValueCallable<ReturnType> {
		CacheValueCallable(self)
	}
}
