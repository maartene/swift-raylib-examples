//
//  GameOverScene.swift
//  swift-raylib  
//
//  Created by Christophe Bronner on 2021-12-27.
//

import RaylibKit

struct GameOverScene: Scene {
	func update() -> SceneAction {
		if Keyboard.enter.isPressed {
			return .replace(with: GameplayScene())
		}
		
		return .continue
	}
	
	func draw() {
		Renderer2D.text(center: "PRESS [ENTER] TO PLAY AGAIN", size: 40, color: .gray)
	}
}
