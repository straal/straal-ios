/*
 * CreateTransactionWithCardSpec.swift
 * Created by Kajetan Dąbrowski on 27/01/2018.
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

class CreateTransactionWithCardSpec: QuickSpec {
	override func spec() {

		describe("TransactionWithCard") {

			var sut: CreateTransactionWithCard!
			var card: Card!

			var cryptKeyJson: [String: Any] {
				let data: Data = (try? sut.cryptKeyPayload.call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var straalRequestJson: [String: Any] {
				let data: Data = (try? sut.straalRequestPayload.call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			beforeEach {
				card = Card(
					name: CardholderName(
						firstName: "John",
						surname: "Appleseed"),
					number: CardNumber(rawValue: "4444-4444-4444-4441"),
					cvv: CVV(rawValue: "000"),
					expiry: Expiry(rawValue: (month: 2, year: 2099)))
			}

			afterEach {
				sut = nil
				card = nil
			}

			context("with transaction in usd without reference") {
				beforeEach {
					let transaction = Transaction(amount: 100, currency: "usd")!
					sut = CreateTransactionWithCard(card: card, transaction: transaction)
				}

				describe("Crypt key request json") {
					it("should have correct permission") {
						expect(cryptKeyJson["permission"] as? String).to(equal("v1.transactions.create_with_card"))
					}

					it("should have a transaction key") {
						expect(cryptKeyJson["transaction"] as? [String: Any]).notTo(beNil())
					}

					describe("transaction") {
						var transaction: [String: Any]!

						beforeEach {
							transaction = cryptKeyJson["transaction"] as? [String: Any]
						}

						afterEach {
							transaction = nil
						}

						it("should have correct amount") {
							expect(transaction["amount"] as? Int).to(equal(100))
						}

						it("should have correct currency") {
							expect(transaction["currency"] as? String).to(equal("usd"))
						}

						it("should not have reference") {
							expect(transaction["reference"]).to(beNil())
						}

						it("should have two keys") {
							expect(transaction.count).to(equal(2))
						}
					}
				}

				describe("Straal request json") {
					it("should have correct name") {
						expect(straalRequestJson["name"] as? String).to(equal("John Appleseed"))
					}

					it("should have correct number") {
						expect(straalRequestJson["number"] as? String).to(equal("4444444444444441"))
					}

					it("should have correct cvv") {
						expect(straalRequestJson["cvv"] as? String).to(equal("000"))
					}

					it("should have correct expiry month") {
						expect(straalRequestJson["expiry_month"] as? Int).to(equal(2))
					}

					it("should have correct expiry year") {
						expect(straalRequestJson["expiry_year"] as? Int).to(equal(2099))
					}
				}
			}

			context("with transaction in pln with reference") {
				beforeEach {
					let transaction = Transaction(amount: 1000, currency: "pln", reference: "order:124iygtieurg")!
					sut = CreateTransactionWithCard(card: card, transaction: transaction)
				}

				describe("Crypt key request json") {
					it("should have correct permission") {
						expect(cryptKeyJson["permission"] as? String).to(equal("v1.transactions.create_with_card"))
					}

					it("should have a transaction key") {
						expect(cryptKeyJson["transaction"] as? [String: Any]).notTo(beNil())
					}

					describe("transaction") {
						var transaction: [String: Any]!

						beforeEach {
							transaction = cryptKeyJson["transaction"] as? [String: Any]
						}

						afterEach {
							transaction = nil
						}

						it("should have correct amount") {
							expect(transaction["amount"] as? Int).to(equal(1000))
						}

						it("should have correct currency") {
							expect(transaction["currency"] as? String).to(equal("pln"))
						}

						it("should have a correct reference") {
							expect(transaction["reference"] as? String).to(equal("order:124iygtieurg"))
						}

						it("should have three keys") {
							expect(transaction.count).to(equal(3))
						}
					}
				}

				describe("Straal request json") {
					it("should have correct name") {
						expect(straalRequestJson["name"] as? String).to(equal("John Appleseed"))
					}

					it("should have correct number") {
						expect(straalRequestJson["number"] as? String).to(equal("4444444444444441"))
					}

					it("should have correct cvv") {
						expect(straalRequestJson["cvv"] as? String).to(equal("000"))
					}

					it("should have correct expiry month") {
						expect(straalRequestJson["expiry_month"] as? Int).to(equal(2))
					}

					it("should have correct expiry year") {
						expect(straalRequestJson["expiry_year"] as? Int).to(equal(2099))
					}
				}
			}
		}
	}
}
