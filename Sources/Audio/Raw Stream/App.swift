import RaylibKit

let MAX_SAMPLES = 512
let MAX_SAMPLES_PER_UPDATE = 4096

/// Cycles per second (hz)
var frequency: Float = 440.0

/// Audio frequency, for smoothing
var audioFrequency: Float = 440.0

/// Previous value, used to test if sine needs to be rewritten, and to smoothly modulate frequency
var oldFrequency: Float = 1.0

/// Index for audio rendering
var sineIdx: Float = 0.0

@main struct RawAudioStreamExample: Applet {
	let stream: AudioStream

	/// Buffer for the single cycle waveform we are synthesizing
	var data: [Int16] = Array(repeating: 0, count: MAX_SAMPLES)

	/// Frame buffer, describing the waveform when repeated over the course of a frame
	var writeBuf: [Int16] = Array(repeating: 0, count: MAX_SAMPLES_PER_UPDATE)

	/// Computed size in samples of the sine wave
	var waveLength = 1

	/// Position read in to determine next frequency
	var mousePosition = Vector2(-100, -100)

	/*
	 // Cycles per second (hz)
	 float frequency = 440.0f;

	 // Previous value, used to test if sine needs to be rewritten, and to smoothly modulate frequency
	 float oldFrequency = 1.0f;

	 // Cursor to read and copy the samples of the sine wave buffer
	 int readCursor = 0;
	 */

	init() throws {
		Window.create(800, by: 450, title: "Example - Audio - Raw Audio Streaming")
		Application.target(fps: 30)

		AudioDevice.initialize()
		AudioStream.setBufferSizeDefault(MAX_SAMPLES_PER_UPDATE)

		stream = AudioStream(sampleRate: 44100, sampleSize: 16, channels: 1)
		stream.onCallback(do: AudioInputCallback)

		// Start processing stream buffer (no data loaded currently)
		stream.play()
	}

	mutating func update() {
		// Sample mouse input.
		mousePosition = Mouse.position

		if Mouse.left.isDown {
			frequency = 40 + mousePosition.y
			let pan = mousePosition.x / Window.width.toFloat;
			stream.set(pan: pan)
		}

		// Rewrite the sine wave
		// Compute two cycles to allow the buffer padding, simplifying any modulation, resampling, etc.
		if (frequency != oldFrequency) {
			// Compute wavelength. Limit size in both directions.
			//int oldWavelength = waveLength;
			waveLength = Int(22050 / frequency)
			waveLength.clamp(between: 1, and: MAX_SAMPLES / 2)

			// Write sine wave
			for i in 0..<(waveLength * 2) {
				let tmp = 2 * .pi * Float(i) / waveLength.toFloat
				data[i] = (tmp.sin * 32000.0).toInt16
			}
			// Make sure the rest of the line is flat
			for j in (waveLength * 2)..<MAX_SAMPLES {
				data[j] = 0
			}

			// Scale read cursor's position to minimize transition artifacts
			//readCursor = (int)(readCursor * ((float)waveLength / (float)oldWavelength));
			oldFrequency = frequency;
		}

		/*
		 // Refill audio stream if required
		 if (IsAudioStreamProcessed(stream))
		 {
		 // Synthesize a buffer that is exactly the requested size
		 int writeCursor = 0;

		 while (writeCursor < MAX_SAMPLES_PER_UPDATE)
		 {
		 // Start by trying to write the whole chunk at once
		 int writeLength = MAX_SAMPLES_PER_UPDATE-writeCursor;

		 // Limit to the maximum readable size
		 int readLength = waveLength-readCursor;

		 if (writeLength > readLength) writeLength = readLength;

		 // Write the slice
		 memcpy(writeBuf + writeCursor, data + readCursor, writeLength*sizeof(short));

		 // Update cursors and loop audio
		 readCursor = (readCursor + writeLength) % waveLength;

		 writeCursor += writeLength;
		 }

		 // Copy finished frame to audio stream
		 UpdateAudioStream(stream, writeBuf, MAX_SAMPLES_PER_UPDATE);
		 }
		 */
	}

	func draw() {
		Renderer.pointSize = 20
		Renderer.textColor = .lightGray

		Renderer2D.text("sine frequency: \(Int(frequency))", at: Window.width - 220, 10, color: .red)
		Renderer2D.text("click mouse button to change frequency or pan", at: 10, 10, color: .darkGray)

		// Draw the current buffer state proportionate to the screen
		for i in 0..<Window.width {
			let x = Float(i)
			let y = 250 + 50 * Float(data[i * MAX_SAMPLES / Window.width]) / 32000
			Renderer2D.pixel(at: x, y, .red)
		}
	}

	func unload() {
		AudioDevice.close()
	}

}

// Audio input processing callback
func AudioInputCallback(buffer: UnsafeMutableRawPointer!, frames: UInt32) {
	audioFrequency = frequency + (audioFrequency - frequency) * 0.95

	let incr = audioFrequency / 44100
	let d = buffer.assumingMemoryBound(to: Int16.self)

	for i in 0..<Int(frames) {
		d[i] = Int16(32000 * (2 * .pi * sineIdx).sin)
		sineIdx += incr
		if sineIdx > 1 {
			sineIdx -= 1
		}
	}
}
