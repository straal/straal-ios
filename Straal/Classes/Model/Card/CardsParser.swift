/*
 * CardsParser.swift
 * Created by Bartosz Kamiński on 10/07/2017.
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

public class CardsParser {

	/// Holds card supported by Straal
	internal static let supportedBrands: [CardBrand] = [Visa(), MasterCard(), AmericanExpress()]

	/**
	Retreives a card type for a String identifier used by Straal
	- parameter parsingString: String used to identify card
	- returns: Nil if no card type matches the parsing String or any other card type that matches the card number.
	*/
	public static func cardBrand(for parsingString: String) -> CardBrand? {
		return supportedBrands.filter { $0.parseString == parsingString }.first
	}

	/**
	Retreives a card type for a specific card number by parsing the Issuer Identification Numbers in the registered card types and matching them with the provided card number.
	- parameter number: The card number whose CardBrand should be determined
	- returns: Nil if no card type matches the Issuer Identification Number of the provided card number or any other card type that matches the card number.
	*/
	public static func cardBrand(for number: CardNumber) -> CardBrand? {
		for i in (0...min(number.length, 6)).reversed() {
			if let substring = number.sanitized[incl: 0, excl: i], let substringAsNumber = Int(substring) {
				if let firstMatchingCardType = supportedBrands.first(where: { $0.identifyingDigits.contains(substringAsNumber) }) {
					return firstMatchingCardType
				}
			}
		}
		return nil
	}
}
