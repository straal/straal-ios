/*
 * HttpCallable.swift
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

class HttpCallable: Callable {
	typealias ReturnType = (Data, HTTPURLResponse)

	let requestCallable: AnyCallable<URLRequest>
	let urlSession: UrlSessionAdapting

	init<O: Callable>(requestSource: O, urlSession: UrlSessionAdapting = UrlSessionAdapter.init()) where O.ReturnType == URLRequest {
		self.requestCallable = requestSource.asCallable()
		self.urlSession = urlSession
	}

	func call() throws -> (Data, HTTPURLResponse) {
		let (dataOptional, responseOptional, error) = urlSession.synchronousDataTask(request: try requestCallable.call())
		if let error = error { throw error }
		guard let data = dataOptional,
			let response = responseOptional as? HTTPURLResponse else {
				throw StraalError.unknown
		}
		return (data, response)
	}
}
