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
    // 画像はSKSpriteNode()で扱う
    var bird = SKSpriteNode() // player
    var gameOverImage = SKSpriteNode() // game over image
    let jumpSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false) // jump sound
    let backSound = SKAction.playSoundFileNamed("backSound.mp3", waitForCompletion: false) // background sound
    
    var blockingObjects = SKNode() // SKNodeは画像を使わない 見えないオブジェクト
    var score = Int(0) // スコア（タイマーの計算）
    var scoreLabel = SKLabelNode() // スコア表示
    var pipeTop = SKSpriteNode() // 上の障害物
//    var pipeBottom = SKSpriteNode() // 下の障害物
    
    var timer: Timer = Timer() // 背景画像を動かすためのタイマー
    var gameTimer: Timer = Timer() // ゲームの進行を管理するタイマー
    var timeString = String() // 結果を投稿するための文字列タイム
    
    
    

    override func didMove(to view: SKView) {
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
