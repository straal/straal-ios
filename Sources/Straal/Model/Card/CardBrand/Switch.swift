/*
 * Switch.swift
 * Created by Hubert Kuczyński on 31.01.2018.
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
*  The native supported card type of Switch
*/
public struct Switch: CardBrand {

	public let name = "Switch"

	public let cvvLength = 3

	public let numberGroupings: [[Int]] = [[4, 4, 4, 4], [4, 4, 4, 6], [4, 4, 4, 4, 3]]

	public let identifyingPattern = "^(4903|4905|4911|4936|564182|633110|6333|6759)"

	public init() { }
}

extension Switch: LuhnValidable { }
