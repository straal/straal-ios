/*
 * Transaction.swift
 * Created by Kajetan Dąbrowski on 10/10/2016.
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

/// Represents a transaction
public struct Transaction {

	/// Amount of money
	public let amount: MoneyAmount

	/// Currency of the transaction
	public let currency: Currency

	/// Transaction reference
	public let reference: String?

	/// Initializes a new transaction
	///
	/// - parameter amount:    amount of money. For example 999 represents $9.99
	/// - parameter currency:  currency of the transaction.
	/// - parameter reference:  Transaction reference.
	/// - parameter extraData: Extra data dictionary
	///
	/// - returns: New transaction
	public init(amount: MoneyAmount, currency: Currency, reference: String? = nil) {
		self.amount = amount
		self.currency = currency
		self.reference = reference
	}

	public init?(amount: Int, currency: String, reference: String? = nil) {
		guard let moneyAmount = MoneyAmount(amount), let currency = Currency(currency) else { return nil }
		self.init(amount: moneyAmount, currency: currency, reference: reference)
	}
}

extension Transaction: Encodable {
	enum CodingKeys: String, CodingKey {
		case amount
		case currency
		case reference
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(amount, forKey: .amount)
		try container.encode(currency, forKey: .currency)
		if let reference = reference {
			try container.encode(reference, forKey: .reference)
		}
	}
}
