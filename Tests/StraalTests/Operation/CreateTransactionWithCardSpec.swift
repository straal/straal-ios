/*
 * CreateTransactionWithCardSpec.swift
 * Created by Kajetan Dąbrowski on 27/01/2018.
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

class CreateTransactionWithCardSpec: QuickSpec {

	override func spec() {

		describe("TransactionWithCard") {

			var sut: CreateTransactionWithCard!
			var card: Card!
			let defaultConfiguration: StraalConfiguration = StraalConfiguration(baseUrl: URL(string: "https://backend.com")!)

			var cryptKeyJson: [String: Any] {
				let data: Data = (try? sut.cryptKeyPayload(configuration: defaultConfiguration).call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var straalRequestJson: [String: Any] {
				let data: Data = (try? sut.straalRequestPayload.call()) ?? Data()
				return ((try? JSONSerialization.jsonObject(with: data)) as? [String: Any]) ?? [:]
			}

			var present3DSViewControllerFactoryStub: PresentStraalViewControllerFactory!
			var presentCallableFactoryCalled: Bool = false
			var capturedRedirectURLs: ThreeDSURLs?

			beforeEach {
				card = Card(
					name: CardholderName(
						firstName: "John",
						surname: "Appleseed"),
					number: CardNumber(rawValue: "4444-4444-4444-4441"),
					cvv: CVV(rawValue: "000"),
					expiry: Expiry(rawValue: (month: 2, year: 2099))
				)

				present3DSViewControllerFactoryStub = { urls, present, dismiss, registration in
					presentCallableFactoryCalled = true
					capturedRedirectURLs = try? urls.call()
					return PresentStraalViewControllerCallable(urls: urls, present: present, dismiss: dismiss, notificationRegistration: registration)
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
					sut = CreateTransactionWithCard(
						card: card,
						transaction: transaction,
						present3DSViewController: { _ in },
						dismiss3DSViewController: { _ in }
					)
					sut.presentViewControllerFactory = present3DSViewControllerFactoryStub
				}

				describe("Crypt key request json") {
					it("should have correct permission") {
						expect(cryptKeyJson["permission"] as? String).to(equal("v1.transactions.create_with_card"))
					}

					it("should have a transaction key") {
						expect(cryptKeyJson["transaction"] as? [String: Any]).notTo(beNil())
					}

					describe("transaction") {
						var transaction: [String: Any]?

						beforeEach {
							transaction = cryptKeyJson["transaction"] as? [String: Any]
						}

						afterEach {
							transaction = nil
						}

						it("should have correct amount") {
							expect(transaction?["amount"] as? Int).to(equal(100))
						}

						it("should have correct currency") {
							expect(transaction?["currency"] as? String).to(equal("usd"))
						}

						it("should not have reference") {
							expect(transaction?["reference"]).to(beNil())
						}

						it("should have 3 keys") {
							expect(transaction?.count).to(equal(3))
						}

						describe("authentication_3ds") {
							var authentication3DS: [String: Any]?

							beforeEach {
								authentication3DS = transaction?["authentication_3ds"] as? [String: Any]
							}

							afterEach {
								authentication3DS = nil
							}

							it("should have auth3DS") {
								expect(authentication3DS).notTo(beNil())
							}

							it("should have correct success url") {
								expect(authentication3DS?["success_url"] as? String).to(equal("https://backend.com/x-callback-url/straal/success"))
							}

							it("should have correct failure url") {
								expect(authentication3DS?["failure_url"] as? String).to(equal("https://backend.com/x-callback-url/straal/failure"))
							}

							it("should have count 3") {
								expect(authentication3DS?.count).to(equal(3))
							}

							describe("threeds_v2") {
								var threeDSV2: [String: Any]?

								beforeEach {
									threeDSV2 = authentication3DS?["threeds_v2"] as? [String: Any]
								}

								afterEach {
									threeDSV2 = nil
								}

								it("should have browser key") {
									expect(threeDSV2?["browser"] as? [String: Any]).notTo(beNil())
								}

								it("should have count 1") {
									expect(threeDSV2?.count).to(equal(1))
								}

								describe("browser") {
									var browser: [String: Any]?

									beforeEach {
										browser = threeDSV2?["browser"] as? [String: Any]
									}

									afterEach {
										browser = nil
									}

									it("should have count 4") {
										expect(browser?.count).to(equal(4))
									}

									it("should have correct locale") {
										expect(browser?["language"] as? String).to(equal("pl-PL"))
									}

									it("should have correct accept header") {
										expect(browser?["accept_header"] as? String).to(equal("*/*"))
									}

									it("should have correct user agent") {
										expect(browser?["user_agent"] as? String).notTo(beNil())
									}

									it("should have correct java_enabled") {
										expect(browser?["java_enabled"] as? Bool).to(equal(true))
									}
								}
							}
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

				describe("Response callable") {
					beforeEach {
						let stubURL = URL(string: "https://backend.com/url")!
						let redirectResponse = HTTPURLResponse(
							url: stubURL,
							statusCode: 200,
							httpVersion: nil,
							headerFields: ["Location": "https://straal.com/redirect"]
						)!
						let httpCallable = HttpCallableFake(response: (Data(), redirectResponse))
						_ = sut.responseCallable(httpCallable: httpCallable, configuration: defaultConfiguration)
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
						expect(capturedRedirectURLs?.successURL.absoluteString).to(equal("https://backend.com/x-callback-url/straal/success"))
					}

					it("should pass correct failure url") {
						expect(capturedRedirectURLs?.failureURL.absoluteString).to(equal("https://backend.com/x-callback-url/straal/failure"))
					}
				}
			}

			context("with transaction in pln with reference") {
				beforeEach {
					let transaction = Transaction(amount: 1000, currency: "pln", reference: "order:124iygtieurg")!
					sut = CreateTransactionWithCard(
						card: card,
						transaction: transaction,
						present3DSViewController: { _ in },
						dismiss3DSViewController: { _ in }
					)
					sut.presentViewControllerFactory = present3DSViewControllerFactoryStub
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

						it("should have 4 keys") {
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
			}
		}
	}
}
