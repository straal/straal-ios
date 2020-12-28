/*
 * UrlCreator.swift
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

protocol UrlCreator {
	associatedtype EndpointType: Endpoint
	func url(for endpoint: EndpointType) -> URL

	var baseUrl: URL { get }
	var apiPathPart: String { get }

	init(configuration: StraalConfiguration)
}

extension UrlCreator {
	func url(for endpoint: EndpointType) -> URL {
		return baseUrl.appendingPathComponent(apiPathPart).appendingPathComponent(endpoint.pathPart)
	}
}
