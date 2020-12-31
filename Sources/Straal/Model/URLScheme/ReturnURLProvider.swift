//
/*
 * ReturnURLProvider.swift
 * Created by Michał Dąbrowski on 31/12/2020.
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

protocol ReturnURLProvider {
	func successURL(scheme: URLScheme) -> URL
	func failureURL(scheme: URLScheme) -> URL
}

class ReturnURLProviderImpl: ReturnURLProvider {

	private let domain = "x-callback-url"
	private let path = "straal"

	func successURL(scheme: URLScheme) -> URL {
		url(scheme: scheme.scheme, components: domain, path, "success")
	}

	func failureURL(scheme: URLScheme) -> URL {
		url(scheme: scheme.scheme, components: domain, path, "failure")
	}

	private func url(scheme: String, components: String...) -> URL {
		URL(string: scheme + "://" + components.joined(separator: "/"))!
	}
}
