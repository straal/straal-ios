//
/*
 * ParseRedirectCallable.swift
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

class ParseRedirectCallable: Callable {
	typealias ReturnType = URL

	private let responseCallable: AnyCallable<(Data, HTTPURLResponse)>

	init<O: Callable>(response: O) where O.ReturnType == (Data, HTTPURLResponse) {
		self.responseCallable = response.asCallable()
	}

	func call() throws -> URL {
		let (_, response) = try responseCallable.call()
		guard let redirectLocation: String = response.allHeaderFields["Location"] as? String,
			let redirectURL = URL(string: redirectLocation) else { throw StraalError.unknown }

		return redirectURL
	}
}
