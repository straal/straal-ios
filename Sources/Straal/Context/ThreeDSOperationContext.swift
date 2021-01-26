/*
 * ThreeDSOperationContext.swift
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

/// This is a shared context of a 3DS operation
public class ThreeDSOperationContext: OperationContext {

	internal let urlOpeningHandler: OpenURLContextRegistration & OpenURLContextHandler
	internal let urlProvider: ReturnURLProvider

	internal init(
		urlOpeningHandler: OpenURLContextRegistration & OpenURLContextHandler = OpenURLContextHandlerImpl(),
		urlProvider: ReturnURLProvider = ReturnURLProviderImpl()
	) {
		self.urlOpeningHandler = urlOpeningHandler
		self.urlProvider = urlProvider
	}
}

extension ThreeDSOperationContext: OpenURLContextHandler {
	func handle(_ context: OpenURLContext) {
		urlOpeningHandler.handle(context)
	}
}
