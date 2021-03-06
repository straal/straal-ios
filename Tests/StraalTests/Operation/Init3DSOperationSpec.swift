//
/*
 * Init3DSOperationSpec.swift
 * Created by Michał Dąbrowski on 18/10/2019.
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

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import Straal

@available(*, deprecated)
class Init3DSOperationSpec: QuickSpec {
	override func spec() {

		describe("Init3DSOperation") {

			var sut: Init3DSOperation!
			var card: Card!
			let defaultConfiguration: StraalConfiguration = .testConfiguration(baseUrl: URL(string: "https://backend.com")!, returnURLScheme: "com.straal.App.payments")

			var cryptKeyJson: [String: Any] {
				let data: Data = (try? sut.cryptKeyData(configuration: defaultConfiguration).call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var straalRequestJson: [String: Any] {
				let data: Data = (try? sut.straalRequestData(configuration: defaultConfiguration).call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var present3DSViewControllerFactoryStub: PresentStraalViewControllerFactory!
			var presentCallableFactoryCalled: Bool = false
			var capturedRedirectURLs: ThreeDSURLs?

			beforeEach {
				presentCallableFactoryCalled = false
				card = Card(
					name: CardholderName(
						firstName: "John",
						surname: "Appleseed"),
					number: CardNumber(rawValue: "4444-4444-4444-4441"),
					cvv: CVV(rawValue: "000"),
					expiry: Expiry(rawValue: (month: 2, year: 2099)))

				present3DSViewControllerFactoryStub = { urls, _, _, _ in
					presentCallableFactoryCalled = true
					capturedRedirectURLs = try? urls.call()
					return PresentStraalViewControllerCallableFake(status: .success)
				}
			}

			afterEach {
				sut = nil
				card = nil
				capturedRedirectURLs = nil
				presentCallableFactoryCalled = false
				present3DSViewControllerFactoryStub = nil
			}

			context("with transaction in usd without reference") {
				beforeEach {
					let transaction = Transaction(amount: 100, currency: "usd")!
					sut = Init3DSOperation(
						card: card,
						transaction: transaction,
						present3DSViewController: { _ in },
						dismiss3DSViewController: { _ in }
					)
					sut.presentViewControllerFactory = present3DSViewControllerFactoryStub
				}

				describe("Crypt key request json") {
					it("should have correct permission") {
						expect(cryptKeyJson["permission"] as? String).to(equal("v1.customers.authentications_3ds.init_3ds"))
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

						it("should have a success URL") {
							expect(transaction["success_url"]).notTo(beNil())
						}

						it("should have a failure URL") {
							expect(transaction["failure_url"]).notTo(beNil())
						}

						it("should have a correct success URL") {
							expect(transaction["success_url"] as? String).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/success"))
						}

						it("should have a correct failure URL") {
							expect(transaction["failure_url"] as? String).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/failure"))
						}

						it("should have four keys") {
							expect(transaction.count).to(equal(4))
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

				describe("Response callable with redirect") {
					beforeEach {
						_ = sut.responseCallable(httpCallable: HttpCallableFake.straalResponse(location: "https://straal.com/redirect"), configuration: defaultConfiguration)
					}

					it("should call sf safari presentation callable factory") {
						expect(presentCallableFactoryCalled).to(beTrue())
					}

					it("should pass some urls") {
						expect(capturedRedirectURLs).notTo(beNil())
					}

					it("should pass correct redirect url") {
						expect(capturedRedirectURLs?.redirectURL.absoluteString).to(equal("https://straal.com/redirect"))
					}

					it("should pass correct success url") {
						expect(capturedRedirectURLs?.successURL.absoluteString).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/success"))
					}

					it("should pass correct failure url") {
						expect(capturedRedirectURLs?.failureURL.absoluteString).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/failure"))
					}
				}
			}

			context("with transaction in pln with reference") {
				beforeEach {
					let transaction = Transaction(amount: 1000, currency: "pln", reference: "order:124iygtieurg")!
					sut = Init3DSOperation(card: card, transaction: transaction, present3DSViewController: { _ in }, dismiss3DSViewController: { _ in })
				}

				describe("Crypt key request json") {
					it("should have correct permission") {
						expect(cryptKeyJson["permission"] as? String).to(equal("v1.customers.authentications_3ds.init_3ds"))
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

						it("should have a success URL") {
							expect(transaction["success_url"]).notTo(beNil())
						}

						it("should have a failure URL") {
							expect(transaction["failure_url"]).notTo(beNil())
						}

						it("should have a correct success URL") {
							expect(transaction["success_url"] as? String).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/success"))
						}

						it("should have a correct failure URL") {
							expect(transaction["failure_url"] as? String).to(equal("com.straal.app.payments://sdk.straal.com/x-callback-url/ios/failure"))
						}

						it("should have five keys") {
							expect(transaction.count).to(equal(5))
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
