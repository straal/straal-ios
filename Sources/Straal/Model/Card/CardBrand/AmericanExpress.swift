/*
 * AmericanExpress.swift
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

/**
*  The native supported card type of AmericanExpress
*/
public struct AmericanExpress: CardBrand {

	public let name = "AmericanExpress"

	public let cvvLength = 4

	public let numberGroupings = [[4, 6, 5]]

	public let identifyingPattern = "^3[47]"

	public init() { }
}

extension AmericanExpress: LuhnValidable { }
