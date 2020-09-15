// swift-tools-version:5.2

import PackageDescription

let package = Package(
	name: "Straal",
	platforms: [.iOS(.v9)],
	products: [
		.library(
			name: "Straal",
			type: .static,
			targets: ["Straal"]),
	],
	dependencies: [
		.package(url: "https://github.com/iosdevzone/IDZSwiftCommonCrypto.git", from: "0.13.0"),
		.package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0"),
		.package(url: "https://github.com/Quick/Quick.git", from: "2.0.0")
	],
	targets: [
		.target(
			name: "Straal",
			dependencies: ["IDZSwiftCommonCrypto"],
			path: "Straal"),
		.testTarget(
			name: "StraalTests",
			dependencies: ["Straal", "IDZSwiftCommonCrypto", "Quick", "Nimble"],
			path: "StraalTests"),
	]
)
