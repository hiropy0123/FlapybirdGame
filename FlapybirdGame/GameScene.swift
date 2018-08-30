//
//  GameScene.swift
//  FlapybirdGame
//
//  Created by Hiroki Nakashima on 2018/08/30.
//  Copyright © 2018年 Hiroki Nakashima. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // variables
    var bird = SKSpriteNode() // player
    var gameOverImage = SKSpriteNode() // game over image
    let jumpSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false) // jump sound
    let backSound = SKAction.playSoundFileNamed("backSound.mp3", waitForCompletion: false) // background sound
    

    override func didMove(to view: SKView) {
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
