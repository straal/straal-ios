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
	func successURL(scheme: String) -> URL
	func failureURL(scheme: String) -> URL
}

extension ReturnURLProvider {
	func successURL(configuration: StraalConfiguration) -> URL {
		successURL(scheme: configuration.returnURLScheme ?? "https")
	}

	func failureURL(configuration: StraalConfiguration) -> URL {
		failureURL(scheme: configuration.returnURLScheme ?? "https")
	}
}

class ReturnURLProviderImpl: ReturnURLProvider {
	func successURL(scheme: String) -> URL {
		url(scheme: scheme, lastPathComponent: "success")
	}

	func failureURL(scheme: String) -> URL {
		url(scheme: scheme, lastPathComponent: "failure")
	}

	private func url(scheme: String, lastPathComponent: String) -> URL {
		URL(string: validated(scheme: scheme) + "://" + "sdk.straal.com/x-callback-url/ios/" + lastPathComponent)!
	}

	private func validated(scheme: String?) -> String {
		scheme?.lowercased().trimmingCharacters(in: CharacterSet.urlUserAllowed.inverted) ?? "https"
	}
}
