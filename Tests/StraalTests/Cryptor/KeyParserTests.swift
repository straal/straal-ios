/*
 * KeyParserTests.swift
 * Created by Kajetan Dąbrowski on 25/08/16.
 *
 * Straal SDK for iOS Tests
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
import XCTest

@testable import Straal

class KeyParserTests: XCTestCase {

	var sut: CryptKey!
	let example1CryptFull: [UInt8] = [0x06, 0xfc, 0x9a, 0xef, 0x59, 0x80, 0x02, 0x54, 0x16, 0x2a, 0x50, 0x5c, 0xa9, 0xfe, 0x7f, 0xb4, 0xc8, 0xa6, 0x04, 0xb5, 0x96, 0xa2, 0x3d, 0xcc, 0x31, 0x82, 0xa2, 0x9c, 0xa7, 0x23, 0x4b, 0x69, 0xf6, 0xc7, 0xe5, 0xb3, 0x3b, 0x7c, 0x57, 0xc9, 0xe0, 0x9f, 0x69, 0x08, 0xfd, 0x1a, 0x36, 0x4f, 0xda, 0xf2, 0x5d, 0x5f, 0xa2, 0xbe, 0x9a, 0x31, 0xf2, 0x52, 0x91, 0xf2, 0x04, 0xa0, 0x8b, 0x03, 0x06, 0x5c, 0xcb, 0xb5, 0x4a, 0xb1, 0x85, 0x2b]

	let example1CryptString: String = "06fc9aef59800254162a505ca9fe7fb4c8a604b596a23dcc3182a29ca7234b69f6c7e5b33b7c57c9e09f6908fd1a364fdaf25d5fa2be9a31f25291f204a08b03065ccbb54ab1852b"

	let invalidCryptString1: String = "06fc9aef598002541162a505ca9fe7fb4c8a604b596a23dcc3182a29ca712343234b69f6c7e5b33b7c57c9e09f6908fd1a364fdaf25d5fa2be9a31f25291f204a08b03065ccbb54ab1852b"

	let invalidCryptString2: String = "06fc9aef59800254162a505ca9fe7fb4c8a604b596a23dcc3182a29ga7234b69f6c7e5b33b7c57c9e09f6908fd1a364fdaf25d5fa2be9a31f25291f204a08b03065ccbb54ab1852b"

	let example1CryptId: Data = Data([UInt8]([0x06, 0xfc, 0x9a, 0xef, 0x59, 0x80, 0x02, 0x54]))

	let example1CryptKey: Data = Data([UInt8]([0x16, 0x2a, 0x50, 0x5c, 0xa9, 0xfe, 0x7f, 0xb4, 0xc8, 0xa6, 0x04, 0xb5, 0x96, 0xa2, 0x3d, 0xcc, 0x31, 0x82, 0xa2, 0x9c, 0xa7, 0x23, 0x4b, 0x69, 0xf6, 0xc7, 0xe5, 0xb3, 0x3b, 0x7c, 0x57, 0xc9]))

	let example1CryptVector1: Data = Data([UInt8]([0xe0, 0x9f, 0x69, 0x08, 0xfd, 0x1a, 0x36, 0x4f, 0xda, 0xf2, 0x5d, 0x5f, 0xa2, 0xbe, 0x9a, 0x31]))

	let example1CryptVector2: Data = Data([UInt8]([0xf2, 0x52, 0x91, 0xf2, 0x04, 0xa0, 0x8b, 0x03, 0x06, 0x5c, 0xcb, 0xb5, 0x4a, 0xb1, 0x85, 0x2b]))

	override func setUp() {
		super.setUp()
		sut = try? CryptKey(cryptKeyString: example1CryptString)
	}

	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testCryptKeyParserShouldNotBeNil() {
		XCTAssertNotNil(sut)
	}

	func testCryptKeyShouldInitializeWithData() {
		XCTAssertNotNil(try? CryptKey(cryptKeyData: Data(example1CryptFull)))
	}

	func testCryptKeyParserShouldNotAcceptInvalidCryptString1() {
		XCTAssertThrowsError(try CryptKey(cryptKeyString: invalidCryptString1)) { (error: Error) -> Void in
			XCTAssertEqual(error as? CryptKeyParsingError, CryptKeyParsingError.invalidLength)
		}
	}

	func testCryptKeyParserShouldNotAcceptInvalidCryptString2() {
		XCTAssertThrowsError(try CryptKey(cryptKeyString: invalidCryptString2)) { (error: Error) -> Void in
			XCTAssertEqual(error as? CryptKeyParsingError, CryptKeyParsingError.invalidData)
		}
	}

	func testCryptKeyParserShouldNotAcceptInvalidCryptString3() {
		XCTAssertThrowsError(try CryptKey(cryptKeyString: "")) { (error: Error) -> Void in
			XCTAssertEqual(error as? CryptKeyParsingError, CryptKeyParsingError.invalidLength)
		}
	}

	func testCryptKeyParserShouldNotAcceptInvalidCryptString5() {
		XCTAssertThrowsError(try CryptKey(cryptKeyString: "a")) { (error: Error) -> Void in
			XCTAssertEqual(error as? CryptKeyParsingError, CryptKeyParsingError.invalidData)
		}
	}

	func testCryptKeyParserShouldNotAcceptInvalidCryptString4() {
		XCTAssertThrowsError(try CryptKey(cryptKeyString: "06fc9aef59800254162a505ca9fe7fb4c8a604b596a23dcc3182a29ca7234b69f6c7e5b33b7c57c9e09f6908fd1a364fdaf25d5fa2be9a31f25291f204a08b03065ccbb54ab1852u")) { (error: Error) -> Void in
			XCTAssertEqual(error as? CryptKeyParsingError, CryptKeyParsingError.invalidData)
		}
	}

	func testParserReturnValidKeyId() {
		XCTAssertEqual(sut[.id], example1CryptId)
	}

	func testParserReturnValidKeyIdWhenParsedFromData() {
		XCTAssertEqual(try? CryptKey(cryptKeyData: Data(example1CryptFull))[.id], example1CryptId)
	}

	func testParserReturnValidKeyCryptoKey() {
		XCTAssertEqual(sut[.key], example1CryptKey)
	}

	func testParserReturnValidKeyInitVector1() {
		XCTAssertEqual(sut[.iv1], example1CryptVector1)
	}

	func testParserReturnValidKeyInitVector2() {
		XCTAssertEqual(sut[.iv2], example1CryptVector2)
	}

}
