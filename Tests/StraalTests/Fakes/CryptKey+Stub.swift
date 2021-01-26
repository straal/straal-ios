/*
 * CryptKey+Stub.swift
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

class CryptKeyStub {
	static func cryptKey(permission: CryptKeyPermission) -> Data {
		let json: [String: Any] = [
			"created_at": 1474370062,
			"ttl": 600,
			"id": "bvrjcfomhvfwy",
			"key": "073f26135a0001f0b5865ee331c44c7722069d06ef0699525c1e6f06ee4a681fb7e00ccce7052cf14b0f7b498607156eae68e385305edc5338adad40aca442fec436cbed86d1a56d",
			"permission": permission.permissionString
		]

		return (try? JSONSerialization.data(withJSONObject: json, options: [])) ?? Data()
	}
}
