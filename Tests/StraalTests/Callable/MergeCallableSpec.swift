//
/*
 * MergeCallableSpec.swift
 * Created by Michał Dąbrowski on 19/10/2019.
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

class MergeCallableSpec: QuickSpec {
	override func spec() {
		describe("MergeCallable") {

			it("should correctly merge simple callables") {
				expect { try MergeCallable(SimpleCallable.of(10), SimpleCallable.of(14)) { $0 + $1 }.call() }.to(equal(24))
			}

			it("should correctly merge simple callables") {
				let result = try? MergeCallable(SimpleCallable.of(10), SimpleCallable.of(14)) { ($0, $1) }.call()
				expect(result?.0).to(equal(10))
				expect(result?.1).to(equal(14))
			}

			it("should not call the callable on creation") {
				let spy = CallableSpy(1)
				_ = MapCallable(spy) { $0 + 100 }
				expect(spy.callCount).to(equal(0))
			}

			it("should rethrow when merge closure throws") {
				let sut = MergeCallable(SimpleCallable.of(10), SimpleCallable.of(14)) { _, _ in throw StraalError.unknown }
				expect { try sut.call() }.to(throwError(StraalError.unknown))
			}
		}

		describe("Syntax sugar") {
			it("should correctly map callable with default closure") {
				let result = try? SimpleCallable.of(15).merge(SimpleCallable.of(13)).call()
				expect(result?.0).to(equal(15))
				expect(result?.1).to(equal(13))
			}

			it("should correctly map callable") {
				expect { try SimpleCallable.of(1).merge(SimpleCallable.of(2)) { $0 + $1 }.call() }.to(equal(3))
			}

			it("should correctly rethrow error") {
				expect { try SimpleCallable.of(1).merge(SimpleCallable.of(2)) { _, _ in throw StraalError.unknown }.call() }.to(throwError(StraalError.unknown))
			}
		}
	}
}
