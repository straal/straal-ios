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
	func successURL(baseURL: URL) -> URL
	func failureURL(baseURL: URL) -> URL
}

extension ReturnURLProvider {
	func successURL(configuration: StraalConfiguration) -> URL {
		successURL(baseURL: configuration.backendBaseUrl)
	}

	func failureURL(configuration: StraalConfiguration) -> URL {
		failureURL(baseURL: configuration.backendBaseUrl)
	}
}

class ReturnURLProviderImpl: ReturnURLProvider {

	private let paths = ["x-callback-url", "straal"]

	func successURL(baseURL: URL) -> URL {
		url(baseURL: baseURL, components: paths + ["success"])
	}

	func failureURL(baseURL: URL) -> URL {
		url(baseURL: baseURL, components: paths + ["failure"])
	}

	private func url(scheme: String = "https", baseURL: URL, components: [String]) -> URL {
		URL(string: scheme + "://" + ([host(from: baseURL)] + components).joined(separator: "/"))!
	}

	private func host(from url: URL) -> String {
		guard let host = url.host else {
			fatalError("Could not parse url host in \(url). Host is required for 3DS operation handling")
		}
		return host
	}
}
