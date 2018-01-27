/*
 * BackendUrlCreator.swift
 * Created by Kajetan Dąbrowski on 16/09/16.
 *
 * Straal SDK for iOS Tests
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
import Quick
import Nimble

@testable import Straal

class BackendUrlCreatorSpec: QuickSpec {
	override func spec() {
		describe("BackendUrlCreator") {

			var sut: BackendUrlCreator!

			beforeEach {
				sut = BackendUrlCreator(configuration: StraalConfiguration(baseUrl: URL(string: "https://merchant.backend.com")!))
			}

			afterEach {
				sut = nil
			}

			it("should create correct url for crypt key endpoint") {
				expect(sut.url(for: .cryptKey).absoluteString).to(equal("https://merchant.backend.com/straal/v1/cryptkeys"))
			}
		}
	}
}
