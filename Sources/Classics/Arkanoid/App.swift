//
//  App.swift
//  swift-raylib  
//
//  Created by Christophe Bronner on 2021-12-26.
//

import RaylibKit

@main struct Arkanoid: App {
	var initial: Scene {
		GameplayScene()
	}

	init() {
		Window.create(800, by: 450, title: "Arkanoid")
		Application.target(fps: 60)
	}
}
