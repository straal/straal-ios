/*
 * ReturnURLProviderTests.swift
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
import XCTest
import Nimble

@testable import Straal

class ReturnURLProviderTests: XCTestCase {

	var sut: ReturnURLProviderImpl!

	override func setUp() {
		super.setUp()
		sut = .init()
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testDefaultSuccessReturnURL() {
		expect(self.sut.successURL(baseURL: URL(string: "https://exaple.com/")!).absoluteString).to(equal("https://exaple.com/x-callback-url/straal/success"))
	}

	func testSuccessReturnURLWithDomainPath() {
		expect(self.sut.successURL(baseURL: URL(string: "https://exaple.com/strr")!).absoluteString).to(equal("https://exaple.com/x-callback-url/straal/success"))
	}

	func testSuccessReturnURLWithHTTP() {
		expect(self.sut.successURL(baseURL: URL(string: "http://staging.exaple.com/something")!).absoluteString).to(equal("https://staging.exaple.com/x-callback-url/straal/success"))
	}

	func testDefaultFailureReturnURL() {
		expect(self.sut.failureURL(baseURL: URL(string: "https://exaple.com/")!).absoluteString).to(equal("https://exaple.com/x-callback-url/straal/failure"))
	}

	func testFailureReturnURLWithDomainPath() {
		expect(self.sut.failureURL(baseURL: URL(string: "https://exaple.com/strr")!).absoluteString).to(equal("https://exaple.com/x-callback-url/straal/failure"))
	}

}
