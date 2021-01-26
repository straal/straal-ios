/*
 * IfCallableSpec.swift
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
// swiftlint:disable function_body_length
import Foundation
import Quick
import Nimble
@testable import Straal

class IfCallableSpec: QuickSpec {

	override func spec() {
		describe("IfCallable") {

			it("should correctly evaluate when true") {

				expect { try IfCallable(
					SimpleCallable.just(true),
					SimpleCallable.just(10),
					SimpleCallable.just(11)
				)
				.call()
				}
				.to(equal(10))
			}

			it("should correctly evaluate when false") {
				expect { try IfCallable(
					SimpleCallable.just(false),
					SimpleCallable.just(10),
					SimpleCallable.just(11)
				)
				.call()
				}
				.to(equal(11))
			}

			describe("evaluation") {
				var conditionEvaluated: Bool = false
				var trueEvaluated: Bool = false
				var falseEvaluated: Bool = false

				var trueBranch: SimpleCallable<Int>!
				var falseBranch: SimpleCallable<Int>!

				beforeEach {
					conditionEvaluated = false
					trueEvaluated = false
					falseEvaluated = false
					trueBranch = .init {
						trueEvaluated = true
						return 10
					}
					falseBranch = .init {
						falseEvaluated = true
						return 11
					}
				}

				afterEach {
					trueBranch = nil
					falseBranch = nil
				}

				it("should evaluate condition late") {

					let conditionCallable = SimpleCallable<Bool> {
						conditionEvaluated = true
						return true
					}

					let sut = IfCallable(conditionCallable, trueBranch, falseBranch)

					expect(conditionEvaluated).to(beFalse())
					expect(trueEvaluated).to(beFalse())
					expect(falseEvaluated).to(beFalse())

					let result = try sut.call()

					expect(conditionEvaluated).to(beTrue())
					expect(trueEvaluated).to(beTrue())
					expect(falseEvaluated).to(beFalse())
					expect(result).to(equal(10))
				}

				it("should not evaluate if condition throws") {
					let conditionCallable = SimpleCallable<Bool> {
						conditionEvaluated = true
						throw TestError()
					}

					let sut = IfCallable(conditionCallable, trueBranch, falseBranch)

					expect(conditionEvaluated).to(beFalse())
					expect(trueEvaluated).to(beFalse())
					expect(falseEvaluated).to(beFalse())

					expect { try sut.call() }.to(throwError())

					expect(conditionEvaluated).to(beTrue())
					expect(trueEvaluated).to(beFalse())
					expect(falseEvaluated).to(beFalse())
				}
			}
		}
	}
	
}

private struct TestError: Error {}
