//
/*
 * HTTPCallableFake.swift
 * Created by Michał Dąbrowski on 25/01/2021.
 *
 * Straal SDK for iOS
 * Copyright 2021 Straal Sp. z o. o.
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
@testable import Straal

class HttpCallableFake: HttpCallable {

	var stubResponse: (Data, HTTPURLResponse)

	init(response: (Data, HTTPURLResponse)) {
		self.stubResponse = response
		let fakeURL = URL(string: "https://fake.com")!
		super.init(requestSource: SimpleCallable(URLRequest(url: fakeURL)), configuration: .testConfiguration(baseUrl: fakeURL))
	}

	override func call() throws -> (Data, HTTPURLResponse) {
		return stubResponse
	}

	static func straalResponse(location: String?) -> HttpCallableFake {
		var headers: [String: String] = [:]
		if let location = location {
			headers["Location"] = location
		}
		let stubURL = URL(string: "https://backend.com/url")!
		let redirectResponse = HTTPURLResponse(
			url: stubURL,
			statusCode: 200,
			httpVersion: nil,
			headerFields: headers
		)!
		let data = try? JSONEncoder.default.encode( EncryptedOperationResponse(requestId: "REQ1"))
		return HttpCallableFake(response: (data ?? Data(), redirectResponse))
	}
}
