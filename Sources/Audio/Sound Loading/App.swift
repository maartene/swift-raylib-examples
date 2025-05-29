import RaylibKit

@main struct SoundLoadingExample: Applet {
	let fxWav: Sound
	let fxOgg: Sound

	init() throws {
		Window.create(800, by: 450, title: "Example - Audio - Sound Loading & Playing")
		Application.target(fps: 30)

		AudioDevice.initialize()

		fxWav = Sound(at: "sound.wav", bundle: .module)
		fxOgg = Sound(at: "target.ogg", bundle: .module)
	}

	mutating func update() {
		if Keyboard.space.isPressed {
			fxWav.play()
		}
		if Keyboard.enter.isPressed {
			fxOgg.play()
		}
	}

	func draw() {
		Renderer2D.text("Press SPACE to PLAY the WAV sound!", at: 200, 180)
		Renderer2D.text("Press ENTER to PLAY the OGG sound!", at: 200, 220)
	}

	func unload() {
		AudioDevice.close()
	}

}
