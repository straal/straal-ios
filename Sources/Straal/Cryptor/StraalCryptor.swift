/*
* StraalCryptor.swift
* Created by Kajetan Dąbrowski on 09/09/2016.
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
import IDZSwiftCommonCrypto

protocol Encrypting {
	func encrypt(message: String, key: CryptKey) throws -> Data
	func encrypt(data: Data, key: CryptKey) throws -> Data
}

protocol Decrypting {
	func decrypt(data: Data, key: CryptKey) throws -> String
}

class StraalCryptor: Encrypting, Decrypting {

	enum CryptorError: Error {
		case invalidKey
		case invalidMessage
		case unknown
	}

	private let algorithm = StreamCryptor.Algorithm.aes
	private let algorithmMode = StreamCryptor.Mode.CFB
	private let algorithmPadding = StreamCryptor.Padding.NoPadding

	private let stringEncoding = String.Encoding.utf8

	internal func encrypt(message: String, key: CryptKey) throws -> Data {
		return try encrypt(paddedMessage: paddedMessage(message: message), key: key)
	}

	func encrypt(data: Data, key: CryptKey) throws -> Data {
		return try encrypt(paddedMessage: paddedMessage(message: data), key: key)
	}

	private func encrypt(paddedMessage: [UInt8], key: CryptKey) throws -> Data {
		guard let encryptedMessage = crypt(
			operation: .encrypt,
			key: key[.key].bytesArray,
			initVector: key[.iv1].bytesArray,
			message: paddedMessage
			) else {
				throw CryptorError.unknown
		}

		let encryptedData = Data(key[.id].bytesArray + encryptedMessage)
		guard let convertedData = hexString(fromArray: encryptedData.bytesArray).data(using: .ascii) else {
			throw CryptorError.unknown
		}
		return convertedData
	}

	internal func decrypt(data dataToDecrypt: Data, key: CryptKey) throws -> String {
		guard let encodedString = String(bytes: dataToDecrypt, encoding: .ascii) else {
			throw CryptorError.invalidMessage
		}
		let dataToDecrypt = dataFrom(hexString: encodedString)

		if dataToDecrypt.count < CryptKey.CryptKeyElement.id.byteLength {
			throw CryptorError.invalidMessage
		}
		if !keysMatch(message: dataToDecrypt, key: key) {
			throw CryptorError.invalidKey
		}
		let encryptedData = dataToDecrypt.subdata(in: CryptKey.CryptKeyElement.id.byteLength..<dataToDecrypt.count).bytesArray

		guard let decryptedData: [UInt8] = crypt(
			operation: .decrypt,
			key: key[.key].bytesArray,
			initVector: key[.iv2].bytesArray,
			message: encryptedData)
			else {
				throw CryptorError.invalidKey
		}

		guard let decryptedMessage = decodedMessage(message: decryptedData) else {
			throw CryptorError.invalidMessage
		}
		return decryptedMessage
	}

	private func crypt(
		operation: StreamCryptor.Operation,
		key: [UInt8],
		initVector: [UInt8],
		message: [UInt8]) -> [UInt8]? {
		return IDZSwiftCommonCrypto.Cryptor(
			operation: operation,
			algorithm: algorithm,
			mode: algorithmMode,
			padding: algorithmPadding,
			key: key,
			iv: initVector)
			.update(byteArray: message)?.final()
	}

	private func paddedMessage(message: String) -> [UInt8] {
		return zeroPad(string: message, blockSize: algorithm.blockSize())
	}

	private func paddedMessage(message: Data) -> [UInt8] {
		return zeroPad(array: message.bytesArray, blockSize: algorithm.blockSize())
	}

	private func decodedMessage(message: [UInt8]) -> String? {
		return String(data: Data(removeTrailingZeroPadding(array: message)), encoding: stringEncoding)
	}

	private func keysMatch(message: Data, key: CryptKey) -> Bool {
		return key[.id] == message.subdata(in: 0..<CryptKey.CryptKeyElement.id.byteLength)
	}
}
