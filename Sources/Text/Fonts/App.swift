//
//  App.swift
//  swift-raylib
//
//  Created by Christophe Bronner on 2023-07-09.
//

import RaylibKit

@main struct Fonts: Applet {
	let fonts: [FontMetadata]

	init() {
		Window.create(800, by: 450, title: "Example - Text - Fonts")
		Application.target(fps: 60)

		fonts = [
			FontMetadata("alagard.png", spacing: 2, color: .maroon, message: "ALAGARD FONT designed by Hewett Tsoi"),
			FontMetadata("pixelplay.png", spacing: 4, color: .orange, message: "PIXELPLAY FONT designed by Aleksander Shevchuk"),
			FontMetadata("mecha.png", spacing: 8, color: .darkGreen, message: "MECHA FONT designed by Captain Falcon"),
			FontMetadata("setback.png", spacing: 4, color: .darkBlue, message: "SETBACK FONT designed by Brian Kent (AEnigma)"),
			FontMetadata("romulus.png", spacing: 3, color: .darkPurple, message: "ROMULUS FONT designed by Hewett Tsoi"),
			FontMetadata("pixantiqua.png", spacing: 4, color: .lime, message: "PIXANTIQUA FONT designed by Gerhard Grossmann"),
			FontMetadata("alpha_beta.png", spacing: 4, color: .gold, message: "ALPHA_BETA FONT designed by Brian Kent (AEnigma)"),
			FontMetadata("jupiter_crash.png", spacing: 1, color: .red, message: "JUPITER_CRASH FONT designed by Brian Kent (AEnigma)"),
		]
	}

	func draw() {
		Renderer2D.text("free fonts included with raylib", at: 20, 20, size: 25, alignment: .center, color: .darkGray)
		Renderer2D.line(from: 220, 50, to: 590, 50, color: .darkGray)

		for font in fonts {
			font.draw()
		}
	}
}

struct FontMetadata {
	private static var offset = 0

	let font: Font
	let message: String
	let spacing: Float
	let position: Vector2
	let color: Color

	init(_ name: Path, spacing: Float, color: Color, message: String) {
		font = File(name, bundle: .module).loadAsFont()
		self.spacing = spacing
		self.message = message
		self.color = color

		let measurement = font.measure(message, at: Float(font.size * 2), spacing: spacing)
		let x = Window.size.x - measurement.x
		let y = 60 + font.size + FontMetadata.offset
		position = Vector2(x / 2, Float(y))
		FontMetadata.offset += 45
	}

	func draw() {
		Renderer2D.text(using: font, message, at: position.x, position.y, spacing: spacing, size: Float(font.size * 2), color: color)
	}

}
