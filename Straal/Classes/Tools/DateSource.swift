/*
 * DateSource.swift
 * Created by Kajetan Dąbrowski on 27/09/2016.
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

protocol DateSourcing {
	var currentYear: Int { get }
	var currentMonth: Int { get }
}

class DateSource: DateSourcing {

	// MARK: - Dependencies

	private let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)

	// MARK: - Public API

	var currentYear: Int {
		return calendar.component(.year, from: Date())
	}

	var currentMonth: Int {
		return calendar.component(.month, from: Date())
	}
}
