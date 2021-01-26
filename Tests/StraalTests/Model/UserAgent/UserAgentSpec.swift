/*
 * UserAgentSpec.swift
 * Created by Michał Dąbrowski on 26/01/2021.
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

@testable import Straal

class UserAgentSpec: XCTestCase {

	private var infoDictionaryFake: InfoDictionaryFake {
		.init(
			shortVersion: "1.2.1",
			version: "152",
			bundle: "com.straal.test"
		)
	}

	private var screenFake: ScreenFake {
		.init(scale: 2.0)
	}

	private var deviceFake: DeviceFake {
		.init(
			model: "iPhone",
			systemVersion: "14.3"
		)
	}

	func testSimpleAgent() {
		let userAgent = UserAgent(
			infoDictionary: infoDictionaryFake,
			screen: screenFake,
			device: deviceFake
		)
		let expectedAgent = "com.straal.test/1.2.1(152) (iPhone; iOS 14.3; Scale/2.00)"
		XCTAssertEqual(userAgent.userAgent, expectedAgent)
	}

}
