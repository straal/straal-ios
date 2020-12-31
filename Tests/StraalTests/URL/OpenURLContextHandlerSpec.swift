/*
 * OpenURLContextHandlerSpec.swift
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

class OpenURLContextHandlerSpec: QuickSpec {

	override func spec() {

		describe("OpenURLContextHandlerImpl") {
			var sut: OpenURLContextHandlerImpl!
			var handlerFake: OpenURLContextHandlerFake!
			var openURLContext1: OpenURLContext!
			var openURLContext2: OpenURLContext!

			beforeEach {
				sut = .init()
				handlerFake = .init()
				openURLContext1 = .init(
					url: URL(string: "https://straal.com/return/success")!,
					sourceApplication: nil
				)
				openURLContext2 = .init(
					url: URL(string: "https://straal.com/return/failure")!,
					sourceApplication: "MyBankingApp"
				)
			}

			afterEach {
				handlerFake = nil
				openURLContext1 = nil
				openURLContext2 = nil
				sut = nil
			}

			context("when called without anything registered") {
				beforeEach {
					sut.handle(openURLContext1)
				}

				it("should not call handler") {
					expect(handlerFake.handledContextCalled).to(beEmpty())
				}
			}

			context("when handler is registered") {
				beforeEach {
					sut.register(handler: handlerFake)
				}

				it("should not call anything") {
					expect(handlerFake.handledContextCalled).to(beEmpty())
				}

				context("when url is handled") {
					beforeEach {
						sut.handle(openURLContext1)
					}

					it("should call handle once") {
						expect(handlerFake.handledContextCalled).to(haveCount(1))
					}

					it("should call handle with correct notification") {
						expect(handlerFake.handledContextCalled.first).to(equal(openURLContext1))
					}
				}

				context("when two urls are handled") {
					beforeEach {
						sut.handle(openURLContext1)
						sut.handle(openURLContext2)
					}

					it("should call handle twice") {
						expect(handlerFake.handledContextCalled).to(haveCount(2))
					}

					it("should call handle with correct notifications") {
						expect(handlerFake.handledContextCalled.first).to(equal(openURLContext1))
						expect(handlerFake.handledContextCalled.last).to(equal(openURLContext2))
					}
				}

				context("when unregister is called and notification is called") {
					beforeEach {
						sut.unregister(handler: handlerFake)
						sut.handle(openURLContext1)
					}

					it("should not call handle") {
						expect(handlerFake.handledContextCalled).to(beEmpty())
					}
				}
			}
		}
	}

}
