//
/*
 * CacheValueCallable.swift
 * Created by Michał Dąbrowski on 18/10/2019.
 *
 * Straal SDK for iOS
 * Copyright 2019 Straal Sp. z o. o.
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

class CacheValueCallableSpec: QuickSpec {
	override func spec() {
		describe("CacheValueCallable") {

			var callableSpy: CallableSpy!
			var sut: CacheValueCallable<Int>!

			beforeEach {
				callableSpy = CallableSpy()
				sut = CacheValueCallable(callableSpy)
			}

			afterEach {
				callableSpy = nil
				sut = nil
			}

			it("should return value from wrapped callable") {
				expect { try sut.call() }.to(equal(0))
			}

			it("should return the same value multiple times") {
				expect { try sut.call() }.to(equal(0))
				expect { try sut.call() }.to(equal(0))
				expect { try sut.call() }.to(equal(0))
			}

			context("when called for the first time") {
				beforeEach {
					_ = try? sut.call()
				}

				it("should call wrapped callable") {
					expect(callableSpy.callCount).to(equal(1))
				}

				context("when called for the second time") {
					beforeEach {
						_ = try? sut.call()
					}

					it("should not call wrapped callable again") {
						expect(callableSpy.callCount).to(equal(1))
					}
				}
			}
		}
	}
}
