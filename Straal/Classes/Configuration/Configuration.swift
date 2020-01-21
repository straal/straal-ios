/*
 * Configuration.swift
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

import Foundation

/// Configuration
public struct StraalConfiguration {

	/// Configuration initializer
	///
	/// - Parameters:
	///   - baseUrl: base URL of your backend service that uses Straal SDK and provides crypt key endpoint
	///   - headers: dictionary of key-value pairs that will be added as headers to every HTTP request to your backend service
	///   - cryptKeyPath: Path at which to download crypt keys. It will be appended to `backendBaseUrl` by the SDK. If no value is provided, the default (`/api/v1/cryptkeys`) will be used.
	public init(baseUrl: URL, headers: [String: String]? = nil, cryptKeyPath: String? = nil) {
		self.backendBaseUrl = baseUrl
		self.headers = headers ?? [:]
		self.cryptKeyPath = cryptKeyPath
		self.urlSession = UrlSessionAdapter()
	}

	internal init(baseUrl: URL, headers: [String: String]? = nil, cryptKeyPath: String? = nil, urlSession: UrlSessionAdapting) {
		self.backendBaseUrl = baseUrl
		self.headers = headers ?? [:]
		self.cryptKeyPath = cryptKeyPath
		self.urlSession = urlSession
	}

	/// Base URL of your backend service that uses Straal SDK and provides crypt key endpoint
	public let backendBaseUrl: URL

	/// Path at which to download crypt keys. It will be appended to `backendBaseUrl` by the SDK. If no value is provided, the default (`/api/v1/cryptkeys`) will be used.
	public let cryptKeyPath: String?

	/// Dictionary of key-value pairs that will be added as headers to every HTTP request to your backend service
	public let headers: [String: String]

	internal let straalApiVersion: Int = 1
	internal let backendApiVersion: Int = 1
	internal let straalDefaultHeaders: [String: String] = [:]
	internal let straalApiUrl: URL = URL(string: "https://api.straal.com")!

	internal let urlSession: UrlSessionAdapting

	// MARK: 3D SECURE

	internal let init3DSSuccessURL: URL = URL(string: "https://sdk.straal.com/success")!
	internal let init3DSFailureURL: URL = URL(string: "https://sdk.straal.com/failure")!
}
