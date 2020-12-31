/*
 * CardsParser.swift
 * Created by Bartosz Kamiński on 10/07/2017.
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

public class CardsParser {

	/// Holds cards supported by Straal
	internal static let supportedBrands: [CardBrand] = [VisaElectron(), Switch(), Visa(), MasterCard(), AmericanExpress(), JCB(),
														Bankcard(), Diners(), Discover(), CUP(), InterPayment(), InstaPayment(), Laser(),
														Dankort(), Maestro(), Solo(), UATP()]

	/**
	Retreives a card type for a specific card number by parsing the Issuer Identification Numbers in the registered card types and matching them with the provided card number.
	- parameter number: The card number whose CardBrand should be determined
	- returns: Nil if no card type matches the Issuer Identification Number of the provided card number or any other card type that matches the card number.
	*/
	public static func cardBrand(for number: CardNumber) -> CardBrand? {
		return supportedBrands.compactMap { brand -> (cardBrand: CardBrand, matchLength: Int)? in
			do {
				let regex = try NSRegularExpression(pattern: brand.identifyingPattern, options: [])
				let range = NSRange(location: 0, length: number.length)
				let matches = regex.matches(in: number.sanitized, options: [], range: range)
				if let match = matches.first {
					let matchLength = match.range.length
					return (brand, matchLength)
				}
				return nil
			} catch {
				return nil
			}
		}.min(by: { $0.matchLength > $1.matchLength })?.cardBrand
	}
}
