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
        
        // BGMを再生
        self.run(backSound, withKey: "backSound")
        self.run(jumpSound, withKey: "jumpSound")
        createParts()
        
    }
    
    // オブジェクトの生成
    func createParts() {
        
        let backView = SKSpriteNode(imageNamed: "bg.png")
        backView.position = CGPoint(x: 0, y: 0)
        // 背景画像の描画
        backView.run(SKAction.repeatForever(SKAction.sequence([
            // X方向に右から左へと背景が移動する
            SKAction.moveTo(x: -self.size.width, duration: 13.0),
            SKAction.moveTo(y: 0, duration: 0)
            
        ])))
        
        // 背景を反映させる
        self.addChild(backView)
        
        
        // 背景を複製して2つ作成
        let backView2 = SKSpriteNode(imageNamed: "bg.png")
        backView2.position = CGPoint(x: 0, y: 0)
        // 背景画像の描画
        backView2.run(SKAction.repeatForever(SKAction.sequence([
        // X方向に右から左へと背景が移動する
        SKAction.moveTo(x: 0, duration: 13.0),
        SKAction.moveTo(y: -self.size.width, duration: 0)
        
        ])))
        
        // 背景を反映させる
        self.addChild(backView2)
        
        // 初期化
        bird = SKSpriteNode() // 一番上で定義しているからいらないかも？
        gameOverImage = SKSpriteNode() // 一番上で定義しているからいらないかも？
        blockingObjects = SKSpriteNode() // 一番上で定義しているからいらないかも？ SKNode()じゃないの？
        
        // スコア
        score = Int(0) // 一番上で定義しているからいらないかも？
        scoreLabel = SKLabelNode() // 一番上で定義しているからいらないかも？
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.color = UIColor.white
        scoreLabel.text = "\(score)" // キャスト 数値→文字列
        scoreLabel.zPosition = 14
        scoreLabel.fontSize = 50
        scoreLabel.fontName = "HelveticaNeue-Bold"
        
        // スコア背景
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(
            roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)),
            cornerWidth: 50,
            cornerHeight: 50,
            transform: nil
        )
        let scoreBgColor = UIColor.gray
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = 13
        scoreLabel.addChild(scoreBg)
        
        // タイマーの初期化
        timer = Timer()
        gameTimer = Timer()
        
        // ゲーム内の物理世界
        self.physicsWorld.contactDelegate = self // SKPhysicsContactDelegate のデリゲートメソッド
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        
        // Game再スタートのための初期化
        blockingObjects.removeAllChildren()
        gameOverImage = SKSpriteNode()
        self.addChild(blockingObjects)
        
        // ゲームオーバー画面
        let gameOverTexture = SKTexture(imageNamed: "GameOverImage.jpg")
        gameOverImage = SKSpriteNode(texture: gameOverTexture)
        gameOverImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY) // 中心揃えに配置
        gameOverImage.zPosition = 11
        self.addChild(gameOverImage)
        gameOverImage.isHidden = true
        
        
        // Player Bird
        let birdTexture = SKTexture(imageNamed: "bird.png")
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // physics追加
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2) // birdに衝突判定のコライダー追加。円形のコライダー。半径がbirdの高さの半分の円。
        bird.physicsBody?.isDynamic = true // birdはダイナミック 動的な物体
        bird.physicsBody?.allowsRotation = false // birdは回転しない
        bird.physicsBody?.categoryBitMask = 1
        bird.physicsBody?.collisionBitMask = 2
        bird.physicsBody?.contactTestBitMask = 2
        bird.zPosition = 10
        
        self.addChild(bird)
        
        
        // 地面
        let ground = SKNode()
        ground.position = CGPoint(x: -325, y: -700)
        
        ground.physicsBody?.isDynamic = false // 地面は動かない
        ground.physicsBody?.categoryBitMask = 2
        blockingObjects.addChild(ground)
        
        // タイマーを回す
        timer = Timer.scheduledTimer(
            timeInterval: 4,
            target: self,
            selector: #selector(createPipe),
            userInfo: nil,
            repeats: true
        )
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateScore),
            userInfo: nil,
            repeats: true
        )
        
        
    }
    
    @objc func createPipe() {
        // パイプを生成
        
        // 乱数の作成
        let randomLength = arc4random() % UInt32(self.size.height/2)
        let offset = CGFloat(randomLength) - self.frame.size.height/4
        let gap = bird.size.height * 3
        let pipeTopTexture    = SKTexture(imageNamed: "pipeTop.png")
        pipeTop = SKSpriteNode(texture: pipeTopTexture)
        pipeTop.position = CGPoint(
            x: self.frame.midX + self.frame.width/2,
            y: self.frame.midY + pipeTop.size.height/2 + gap/2 + offset
        )
        pipeTop.physicsBody = SKPhysicsBody(rectangleOf: pipeTop.size) // パイプのカタチをパイプの大きさの長方形にする
        pipeTop.physicsBody?.isDynamic = false // パイプは衝突しても動かない
    }
    
    @objc func updateScore() {
        // スコアを更新
        score += 1
        scoreLabel.text = "\(score)"
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
