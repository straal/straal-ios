/*
 * CreateTransactionWithCard+StraalRequestPayload.swift
 * Created by Michał Dąbrowski on 27/01/2021.
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

extension CreateTransactionWithCard {

	// swiftlint:disable nesting

	struct StraalRequestPayload: Encodable {
		private let card: Card
		private let browser: Browser

		func encode(to encoder: Encoder) throws {
			try card.encode(to: encoder)

			var container = encoder.container(keyedBy: BrowserCodingKeys.self)
			let superEncoder = container.superEncoder(forKey: .browser)
			try browser.encode(to: superEncoder)
		}

		enum BrowserCodingKeys: String, CodingKey {
			case browser
		}

		init(
			card: Card,
			language: String,
			userAgent: String
		) {
			self.card = card
			self.browser = .init(
				language: language,
				userAgent: userAgent
			)
		}
	}

	private struct Browser: Encodable {
		let acceptHeader: String = "*/*"
		let javaEnabled: Bool = true
		let language: String
		let userAgent: String
	}

	// swiftlint:enable nesting

}
