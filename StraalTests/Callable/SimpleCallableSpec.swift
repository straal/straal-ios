/*
 * SimpleCallableSpec.swift
 * Created by Kajetan Dąbrowski on 24/01/2018.
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

class SimpleCallableSpec: QuickSpec {
	override func spec() {
		describe("SimpleCallable") {
			it("should return passed int value") {
				expect { try SimpleCallable.of(1).call() }.to(equal(1))
			}

			it("should return passed double value") {
				expect { try SimpleCallable.of(4.22).call() }.to(equal(4.22))
			}

			it("should return passed string value") {
				expect { try SimpleCallable.of("123").call() }.to(equal("123"))
			}

			it("should return correctly retain value when working with an object") {
				var object: NSObject? = NSObject()
				let callable = SimpleCallable.of(object)
				object = nil
				expect { try callable.call() }.notTo(beNil())
			}

			it("should return return the same object") {
				let object = NSObject()
				let callable = SimpleCallable.of(object)
				expect { try callable.call() }.to(be(object))
			}
		}

		describe("AnyCallable") {
			it("should return passed value when as callable") {
				expect { try SimpleCallable.of(1).asCallable().call() }.to(equal(1))
			}

			it("should return correct value when working with an object even if anonymous") {
				var object: NSObject? = NSObject()
				let callable = SimpleCallable.of(object).asCallable()
				object = nil
				expect { try callable.call() }.notTo(beNil())
			}

			it("should return return the same object") {
				let object = NSObject()
				let callable = SimpleCallable.of(object).asCallable()
				expect { try callable.call() }.to(be(object))
			}
		}
	}
}
