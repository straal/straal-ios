/*
 * PresentStraalViewControllerCallableFake.swift
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

@testable import Straal

class PresentStraalViewControllerCallableFake: PresentStraalViewControllerCallable {

	private let status: Encrypted3DSOperationStatus

	init(status: Encrypted3DSOperationStatus) {
		self.status = status
		let fakeURL = URL(string: "https://straal.com")!
		let threeDSURLs = ThreeDSURLs(redirectURL: fakeURL, successURL: fakeURL, failureURL: fakeURL)
		let registration = OpenURLContextRegistrationFake()
		super.init(
			urls: SimpleCallable.just(threeDSURLs).asCallable(),
			present: { _ in fatalError("Invalid in tests") },
			dismiss: { _ in fatalError("Invalid in tests") },
			notificationRegistration: SimpleCallable.just(registration).asCallable(),
			notificationHandlerFactory: { _, _, _ in fatalError("Invalid in tests") },
			viewControllerFactory: { _ in fatalError("Invalid in tests") }
			)
	}

	override func call() throws -> Encrypted3DSOperationStatus {
		return status
	}
}
