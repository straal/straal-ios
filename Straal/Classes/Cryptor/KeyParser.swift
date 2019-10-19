/*
 * KeyParser.swift
 * Created by Kajetan Dąbrowski on 25/08/2016.
 *
 * Straal SDK for iOS
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

enum CryptKeyParsingError: Error {
	case invalidLength
	case invalidData
}

struct CryptKey {
	enum CryptKeyElement {
		case id
		case key
		case iv1
		case iv2

		var byteLength: Int {
			switch self {
			case .id:
				return 8
			case .key:
				return 32
			case .iv1, .iv2:
				return 16
			}
		}

		static let all: [CryptKeyElement] = [.id, .key, .iv1, .iv2]

		var startIndex: Int {
			return CryptKeyElement.all.split(separator: self, omittingEmptySubsequences: false)
				.first!
				.reduce(0) { $0 + $1.byteLength }
		}

		static let keyLength: Int = {
			return all.reduce(0) { $0 + $1.byteLength }
		}()
	}

	private let expectedKeyLength: Int = CryptKeyElement.keyLength
	private let keyData: Data

	init(cryptKeyString: String) throws {
		guard let keyData = Data(hexString: cryptKeyString) else {
			throw CryptKeyParsingError.invalidData
		}
		try self.init(cryptKeyData: keyData)
	}

	init(cryptKeyData: Data) throws {
		if cryptKeyData.count != expectedKeyLength {
			throw CryptKeyParsingError.invalidLength
		}
		self.keyData = cryptKeyData
	}

	subscript(index: CryptKeyElement) -> Data {
		let fromIndex = keyData.index(index.startIndex, offsetBy: 0)
		let toIndex = keyData.index(index.startIndex, offsetBy: index.byteLength)

		return keyData.subdata(in: fromIndex..<toIndex)
	}
}

extension Data {
	init?(hexString: String) {

		var bytes: [UInt8] = []
		let length = hexString.distance(from: hexString.startIndex, to: hexString.endIndex)

		for index in stride(from: 0, to: length, by: 2) {
			let fromIndex = hexString.index(hexString.startIndex, offsetBy: index)
			if hexString.distance(from: fromIndex, to: hexString.endIndex) < 2 { return nil }
			let toIndex = hexString.index(hexString.startIndex, offsetBy: index + 2)
			let num: UInt8? = UInt8(hexString[fromIndex..<toIndex], radix: 16)
			guard let unwrappedNum = num else { return nil }
			bytes.append(unwrappedNum)
		}

		self.init(bytes: bytes)
	}

	var bytesArray: [UInt8] {
		return withUnsafeBytes {
			[UInt8](UnsafeBufferPointer(start: $0, count: count))
		}
	}
}

extension CryptKey: Decodable {
	enum CodingKeys: String, CodingKey {
		case key
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let keyString = try values.decode(String.self, forKey: .key)
		try self.init(cryptKeyString: keyString)
	}
}
