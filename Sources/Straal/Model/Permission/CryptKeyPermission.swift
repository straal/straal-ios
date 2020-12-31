/*
 * CryptKeyPermission.swift
 * Created by Kajetan Dąbrowski on 16/09/2016.
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

enum CryptKeyPermission: Encodable {
	case cardsCreate
	case transactionCardCreate
	case authentication3DS

	var permissionString: String {
		switch self {
		case .cardsCreate:
			return "v1.cards.create"
		case .transactionCardCreate:
			return "v1.transactions.create_with_card"
		case .authentication3DS:
			return "v1.customers.authentications_3ds.init_3ds"
		}
	}

	enum CodingKeys: String, CodingKey {
		case permission
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(permissionString, forKey: .permission)
	}
}
