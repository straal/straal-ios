/*
 * UrlSessionAdapter.swift
 * Created by Kajetan Dąbrowski on 12/09/2016.
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

// swiftlint:disable large_tuple

import Foundation

protocol UrlSessionAdapting {
	func synchronousDataTask(request: URLRequest) -> (Data?, URLResponse?, Error?)
}

class UrlSessionAdapter: UrlSessionAdapting {

	private static let urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

	func synchronousDataTask(request: URLRequest) -> (Data?, URLResponse?, Error?) {
		return UrlSessionAdapter.urlSession.synchronousDataTask(urlRequest: request)
	}
}
