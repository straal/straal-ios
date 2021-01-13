/*
* CreateCard.swift
* Created by Kajetan Dąbrowski on 26/01/2018.
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

/// Main class for performing Straal requests
public final class Straal {

	/// Your configuration
	public let configuration: StraalConfiguration

	/// The queue that executes the task (including networking)
	public let asyncQueue: DispatchQueue

	/// Initializes the Straal utility object
	///
	/// - Parameters:
	///   - configuration: your configuration
	///   - queue: a queue for `perform(operation:)` method
	public init(configuration: StraalConfiguration, queue: DispatchQueue) {
		self.configuration = configuration
		self.asyncQueue = queue
	}

	/// Initializes the Straal utility object
	///
	/// - Parameter configuration: your Straal configuration
	public convenience init(configuration: StraalConfiguration) {
		self.init(configuration: configuration, queue: DispatchQueue(label: "com.straal.execution_queue"))
	}

	// MARK: - Public API

	/// Performs your task on the queue that it's called on, and returns a correct response, or throws an error from one of the tasks
	/// @warn: Do not call this on the main queue, as it's a blocking call
	///
	/// - Parameter operation: operation to execute
	/// - Returns: the final result of the operation
	/// - Throws: StraalError or any system error that might have happened
	public func performSync<O: StraalOperation, T>(operation: O) throws -> T where O.Response == T {
		configuration.operationContextContainer.register(context: operation.context)
		defer { configuration.operationContextContainer.unregister(context: operation.context) }
		return try operation.perform(configuration: configuration)
	}

	/// Performs your task in a background queue. Calls completion closure after the task is finished
	///
	/// - Parameters:
	///   - operation: operation to execute
	///   - completion: completion closure that is called after the task finishes
	public func perform<O: StraalOperation, T>(operation: O, completion: @escaping ((T?, Error?) -> Void)) where O.Response == T {
		asyncQueue.async {
			do {
				completion(try self.performSync(operation: operation), nil)
			} catch {
				completion(nil, error)
			}
		}
	}
}

public extension Straal {

	/// Use this to handle external user activity in your `SceneDelegate` class
	/// - Parameter userActivity: user activity
	class func handle(_ userActivity: NSUserActivity) {
		if let openURLContext = userActivity.openURLContext {
			OperationContextContainerImpl
				.shared
				.registered
				.compactMap { $0 as? OpenURLContextHandler }
				.forEach { $0.handle(openURLContext) }
		}
	}

	/// Use this to handle external user activity in your `SceneDelegate` class
	/// - Parameter userActivity: user activity
	func handle(_ userActivity: NSUserActivity) {
		if let openURLContext = userActivity.openURLContext {
			configuration
				.operationContextContainer
				.registered
				.compactMap { $0 as? OpenURLContextHandler }
				.forEach { $0.handle(openURLContext) }
		}
	}

}

/// Use this to avoid confusion between module and class name
public typealias StraalMain = Straal
