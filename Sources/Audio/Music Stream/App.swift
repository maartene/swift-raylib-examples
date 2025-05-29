import RaylibKit

@main struct MusicStreamExample: Applet {
	let music: Music
	var pause = false
	var timePlayed: Float = 0

	init() throws {
		Window.create(800, by: 450, title: "Example - Audio - Music Stream")
		Application.target(fps: 30)

		AudioDevice.initialize()

		music = try Music(at: "country.mp3", bundle: .module)
		music.play()
	}

	mutating func update() {
		// Update music buffer with new stream data
		music.update()

		// Restart music playing (stop and play)
		if Keyboard.space.isPressed {
			music.restart()
		}

		// Pause/Resume music playing
		if Keyboard.p.isPressed {
			pause.toggle()
			music.paused(is: pause)
		}


		// Get normalized time played for current music stream
		// Make sure time played is no longer than music
		timePlayed = min(music.progress, 1)
	}

	func draw() {
		Renderer.pointSize = 20
		Renderer.textColor = .lightGray
		Renderer2D.text("MUSIC SHOULD BE PLAYING!", at: 255, 150)

		Renderer2D.rectangle(at: 200, 200, size: 400, 12, color: .lightGray)
		Renderer2D.rectangle(at: 200, 200, size: (timePlayed * 400).toInt, 12, color: .maroon)
		WireRenderer2D.rectangle(at: 200, 200, size: 400, 12, color: .gray)

		Renderer2D.text("PRESS SPACE TO RESTART MUSIC", at: 215, 250)
		Renderer2D.text("PRESS P TO PAUSE/RESUME", at: 215, 280)
	}

	func unload() {
		AudioDevice.close()
	}

}
