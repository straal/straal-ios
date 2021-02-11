/*
 * StraalTests.swift
 * Created by Michał Dąbrowski on 13/01/2021.
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
import XCTest
import Nimble

@testable import Straal

class StraalTests: XCTestCase {

	var sut: Straal!
	var configuration: StraalConfiguration!
	var operationContextContainerFake: OperationContextContainerFake!
	var urlSessionAdapterFake: UrlSessionAdapterFake!

	override func setUp() {
		super.setUp()
		operationContextContainerFake = .init()
		urlSessionAdapterFake = .init()

		configuration = .testConfiguration(
			urlSession:urlSessionAdapterFake,
			operationContextContainer: operationContextContainerFake
		)

		sut = Straal(configuration: configuration)
	}

	override func tearDown() {
		sut = nil
		configuration = nil
		urlSessionAdapterFake = nil
		operationContextContainerFake = nil
		super.tearDown()
	}

	func testDoesNotRegisterByDefault() {
		_ = SimpleOperation()
		expect(self.operationContextContainerFake.registerCalled).to(beEmpty())
		expect(self.operationContextContainerFake.unregisterCalled).to(beEmpty())
	}

	func testRegistersForSimpleOperation() {
		let operation = SimpleOperation()
		_ = try? sut.performSync(operation: operation)
		expect(self.operationContextContainerFake.registerCalled).to(haveCount(1))
		expect(self.operationContextContainerFake.unregisterCalled).to(haveCount(1))
	}
}

private struct SimpleResponse: StraalResponse {}

private class SimpleTestOperationContext: OperationContext, Equatable {
	var uuid: UUID = .init()

	static func == (lhs: SimpleTestOperationContext, rhs: SimpleTestOperationContext) -> Bool {
		lhs.uuid == rhs.uuid
	}
}

private class SimpleOperation: StraalOperation {
	let context: SimpleTestOperationContext = .init()

	typealias Response = SimpleResponse
	typealias Context = SimpleTestOperationContext

	func perform(configuration: StraalConfiguration) throws -> SimpleResponse {
		return SimpleResponse()
	}
}
