/*
 * VersionAdapterFake.swift
 * Created by Bartosz Kamiński on 26/01/2018.
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

@testable import Straal

final class VersionAdapterFake: VersionAdapting {

	// MARK: - VersionAdapting

	var versionCalled: Bool = false
	var versionToReturn: String?
	var version: String? {
		versionCalled = true
		return versionToReturn
	}
}
