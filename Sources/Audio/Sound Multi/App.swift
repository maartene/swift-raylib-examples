import RaylibKit

let MAX_SOUNDS = 10

@main struct SoundLoadingExample: Applet {
	let sounds: [Sound]
	var currentSound = 0

	init() throws {
		Window.create(800, by: 450, title: "Example - Audio - Sound Loading & Playing")
		Application.target(fps: 60)

		AudioDevice.initialize()

		let sound = Sound(at: "sound.wav", bundle: .module)
		var tmp = Array(repeating: sound, count: MAX_SOUNDS)

		for i in tmp.indices {
			tmp[i] = sound.alias()
		}
		self.sounds = tmp
	}

	mutating func update() {
		if Keyboard.space.isPressed {
			sounds[currentSound].play()
			currentSound = (currentSound + 1) % sounds.count
		}
	}

	func draw() {
		Renderer2D.text("Press SPACE to PLAY a WAV sound!", at: 200, 180)
	}

	func unload() {
		AudioDevice.close()
	}

}
