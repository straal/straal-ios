/*
 * BundleVersionAdapter.swift
 * Created by Bartosz Kamiński on 26/01/2018.
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

import Foundation

protocol VersionAdapting {
	var version: String? { get }
}

extension VersionAdapting where Self: InfoDictionaryAdapter {
	var version: String? {
		object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}
}

extension Bundle: VersionAdapting { }

final class VersionAdapter: VersionAdapting {
	var version: String? {
		Bundle(for: type(of: self)).version
	}
}
