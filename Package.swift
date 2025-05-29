// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "swift-raylib-examples",
	dependencies: [
		.package(url: "https://github.com/Lancelotbronner/swift-raylib", from: "5.5.2"),
	],
	targets: [

		// Audio Module
		.example(.audio, "Module Playing", [
			.copy("mini1111.xm"),
		]),
		.example(.audio, "Music Stream", [
			.copy("country.mp3"),
		]),
		.example(.audio, "Raw Stream"),
		.example(.audio, "Sound Loading", [
			.copy("sound.wav"),
			.copy("target.ogg"),
		]),
		.example(.audio, "Sound Multi", [
			.copy("sound.wav"),
		]),

		// Classics
		.classic("Arkanoid"),
//		.classic("Platformer"),
		.classic("Snake"),

		// Core Module
		.example(.core, "Basic Window"),
		.example(.core, "Input Keys"),
		.example(.core, "Input Mouse"),
		.example(.core, "Input Mouse Wheel"),
		.example(.core, "2D Camera"),
		.example(.core, "2D Camera Mouse Zoom"),
		.example(.core, "2D Camera Platformer"),
		.example(.core, "Letterboxed Window"),
		.example(.core, "Drop Files"),
		.example(.core, "Scissor Test"),
//		.example(.core, "3D First Person"),

		// Games
//		.game("HexTrader", resources: true, assets: true),
//		.game("RPG Example", resources: true),

		// Shapes Module
		.example(.shapes, "Basic Shapes"),
		.example(.shapes, "Bouncing Ball"),
		.example(.shapes, "Color Palette"),
		.example(.shapes, "Following Eyes"),

		// Text Module
		.example(.text, "Fonts", [
			.copy("alagard.png"),
			.copy("alpha_beta.png"),
			.copy("jupiter_crash.png"),
			.copy("mecha.png"),
			.copy("pixantiqua.png"),
			.copy("pixelplay.png"),
			.copy("romulus.png"),
			.copy("setback.png"),
		]),

		// Textures Module
		.example(.textures, "Atlas", [
			.copy("scarfy.png"),
		]),
		.example(.textures, "Blend Modes", [
			.copy("background.png"),
			.copy("foreground.png"),
		]),
		.example(.textures, "Image Generation"),
		.example(.textures, "Logo Raylib", [
			.copy("logo.png"),
		]),
		.example(.textures, "Sprite Animation", [
			.copy("scarfy.png"),
		]),
	]
)

//MARK: - Templates

enum RaylibModule: String {
	case audio = "Audio"
	case core = "Core"
	case shapes = "Shapes"
	case text = "Text"
	case textures = "Textures"
}

extension Target.Dependency {
	static let raylib = Self.product(name: "RaylibKit", package: "swift-raylib")
}

extension Target {
	static func example(_ module: RaylibModule, _ name: String, _ resources: [Resource]? = nil, _ exclude: [String] = [], license: Bool = false) -> Target {
		var exclude = exclude
		if license {
			exclude.append("LICENSE.md")
		}
		let target = Target.executableTarget(
			name: "\(module.rawValue) - \(name)",
			dependencies: [.raylib],
			path: "Sources/\(module.rawValue)/\(name)",
			exclude: exclude,
			resources: resources)
		return target
	}
	
	static func classic(_ name: String, _ resources: [Resource]? = nil) -> Target {
		let target = Target.executableTarget(
			name: "Classic Game - \(name)",
			dependencies: [.raylib],
			path: "Sources/Classics/\(name)",
			resources: resources)
		return target
	}
	
	static func game(_ name: String, resources: Bool = false, assets: Bool = false) -> Target {
		let target = Target.executableTarget(
			name: "Game - \(name)",
			dependencies: [.raylib],
			path: "Sources/Games/\(name)",
			resources: [])
		if resources {
			target.resources?.append(.copy("Resources/"))
		}
		if assets {
			target.exclude.append("Assets")
		}
		return target
	}
}
