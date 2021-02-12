/*
 * CatchErrorJustReturnCallableSpec.swift
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
import Quick
import Nimble
@testable import Straal

class CatchErrorJustReturnCallableSpec: QuickSpec {

	override func spec() {
		describe("CatchErrorJustReturnCallable") {

			it("should evaluate and pass value") {
				expect { try CatchErrorJustReturnCallable(
					SimpleCallable.just(true),
					default: false
				)
				.call()
				}
				.to(beTrue())
			}

			it("should catch") {
				expect { try CatchErrorJustReturnCallable(
					SimpleCallable { throw TestError() },
					default: false
				)
				.call()
				}
				.notTo(throwError())
			}

			it("should return default value") {
				expect { try CatchErrorJustReturnCallable(
					SimpleCallable { throw TestError() },
					default: false
				)
				.call()
				}
				.to(equal(false))
			}

		}
	}

}

private struct TestError: Error {}
