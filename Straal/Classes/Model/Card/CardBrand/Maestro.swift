/*
 * Maestro.swift
 * Created by Hubert Kuczyński on 31.01.2018.
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

/**
*  The native supported card type of Maestro
*/
public struct Maestro: CardBrand {

	public let name = "Maestro"

	public let cvvLength = 3

	public var numberGroupings: [[Int]] = [[4, 4, 4], [4, 4, 5], [4, 4, 6], [4, 4, 4, 3],
										   [4, 4, 4, 4], [4, 4, 4, 5], [4, 4, 4, 6], [4, 4, 4, 4, 3]]

	public let identifyingPattern = "^(50|5[6-9]|6019|603220)"

	public init() { }
}

extension Maestro: LuhnValidable { }
