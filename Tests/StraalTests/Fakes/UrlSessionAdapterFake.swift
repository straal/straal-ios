/*
 * UrlSessionAdapterFake.swift
 * Created by Bartosz Kamiński on 25/01/2018.
 *
 * Straal SDK for iOS Tests
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

// swiftlint:disable large_tuple

import Foundation

@testable import Straal

final class UrlSessionAdapterFake: UrlSessionAdapting {

	// MARK: - UrlSessionAdapting

	var synchronousDataTaskCalled: Bool { return synchronousDataTaskCallCount > 0 }
	var synchronousDataTaskCallCount: Int = 0
	var synchronousDataTaskCapturedRequests: [URLRequest] = []
	var synchronousDataTasksToReturn: [(Data?, URLResponse?, Error?)] = []
	func synchronousDataTask(request: URLRequest) -> (Data?, URLResponse?, Error?) {
		synchronousDataTaskCallCount += 1
		synchronousDataTaskCapturedRequests.append(request)
		return synchronousDataTasksToReturn[synchronousDataTaskCallCount - 1]
	}
}
