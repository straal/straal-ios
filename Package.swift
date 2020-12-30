// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "Straal",
	platforms: [.iOS(.v13)],
	products: [
		.library(
			name: "Straal",
			targets: ["Straal"]),
	],
	dependencies: [
		.package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),
		.package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
		.package(url: "https://github.com/iosdevzone/IDZSwiftCommonCrypto.git", .upToNextMajor(from: "0.13.0")),
	],
	targets: [
		.target(
			name: "Straal",
			dependencies: ["IDZSwiftCommonCrypto"]),
		.testTarget(
			name: "StraalTests",
			dependencies: ["Straal", "IDZSwiftCommonCrypto", "Quick", "Nimble"]),
	]
)
