//
//  Model.swift
//  swift-raylib
//
//  Created by Christophe Bronner on 2021-12-26.
//

import RaylibKit

enum Configuration {
	/// The number of lives for the player
	static let playerLives = 5
	
	/// The number of lines of bricks
	static let linesOfBricks = 5
	
	/// The number of bricks per line
	static let bricksPerLine = 20
}

struct Player {
	var body: Rectangle
	var lives: Int
}

struct Ball {
	var body: Circle
	var speed: Vector2
	var isActive: Bool
}

struct Brick {
	var position: Vector2
	var isActive: Bool
}
