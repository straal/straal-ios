/*
 * ParseErrorCallable.swift
 * Created by Kajetan Dąbrowski on 24/01/2018.
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

class ParseErrorCallable: Callable {
	typealias ReturnType = (Data, HTTPURLResponse)

	var responseCallable: AnyCallable<(Data, HTTPURLResponse)>

	init<O: Callable>(response: O) where O.ReturnType == (Data, HTTPURLResponse) {
		self.responseCallable = response.asCallable()
	}

	func call() throws -> (Data, HTTPURLResponse) {
		let (data, response) = try responseCallable.call()
		switch response.statusCode {
		case 200..<300:
			return (data, response)
		case 400: throw StraalError.badRequest
		case 402: throw StraalError.payment
		case 500: throw StraalError.unknown
		case 401: throw StraalError.unauthorized
		case 404: throw StraalError.notFound
		case 502: throw StraalError.notFound
		default: throw StraalError.unknown
		}
	}
}

class ExtractBodyCallable: Callable {
	typealias ReturnType = Data

	var responseCallable: AnyCallable<(Data, HTTPURLResponse)>

	init<O: Callable>(response: O) where O.ReturnType == (Data, HTTPURLResponse) {
		self.responseCallable = response.asCallable()
	}

	func call() throws -> Data {
		return try responseCallable.call().0
	}
}
