/*
 * OpenURLContextParser.swift
 * Created by Michał Dąbrowski on 31/12/2020.
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

internal class OpenURLContextParser: OpenURLContextHandler {

	let urls: ThreeDSURLs
	let onSuccess: () -> Void
	let onFailure: () -> Void

	init(
		urls: ThreeDSURLs,
		onSuccess: @escaping () -> Void,
		onFailure: @escaping () -> Void
	) {
		self.urls = urls
		self.onSuccess = onSuccess
		self.onFailure = onFailure
	}

	func handle(_ context: OpenURLContext) {
		switch context.url {
		case urls.successURL: onSuccess()
		case urls.failureURL: onFailure()
		default: return
		}
	}
}
