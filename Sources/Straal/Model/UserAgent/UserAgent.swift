/*
 * UserAgent.swift
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
import UIKit

protocol UserAgentGeneration {
	var userAgent: String { get }
}

class UserAgent: UserAgentGeneration {

	private let infoDictionary: InfoDictionaryAdapter
	private let screen: ScreenAdapter
	private let device: DeviceAdapter

	init(
		infoDictionary: InfoDictionaryAdapter = Bundle.main,
		screen: ScreenAdapter = UIScreen.main,
		device: DeviceAdapter = UIDevice.current
	) {
		self.infoDictionary = infoDictionary
		self.screen = screen
		self.device = device
	}

	lazy var userAgent: String = {
		let appShortVersionOptional = infoDictionary.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		let appVersionOptional = infoDictionary.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
		let appNameOptional = infoDictionary.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String

		let appShortVersion = appShortVersionOptional ?? "unknown"
		let appVersion = appVersionOptional ?? "unknown"
		let appName = appNameOptional ?? "unknown"

		let scale = String(format: "%0.2f", screen.scale)

		let model = device.model
		let systemVersion = device.systemVersion

		return "\(appName)/\(appShortVersion)(\(appVersion)) (\(model); iOS \(systemVersion); Scale/\(scale))"

	}()
}
