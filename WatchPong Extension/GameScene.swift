//
//  GameScene.swift
//  WatchPong Extension
//
//  Created by Michael Castillo on 4/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import SpriteKit
import WatchKit

class GameScene: SKScene {
    
    fileprivate let pongBallString = "pongBall"
    fileprivate let borderString = "border"
    fileprivate let scoreLabelString = "scoreLabel"
    fileprivate let paddleString = "paddle"
    fileprivate let labelString = "label"
    
    fileprivate var isPaddleBeingTouched = true
    fileprivate var paddleLabel: SKLabelNode?
    fileprivate var ball: SKSpriteNode?
    fileprivate var paddle: SKSpriteNode?
    fileprivate var border: SKSpriteNode?
    fileprivate var scoreLabel: SKSpriteNode?
    
    static var label: SKLabelNode = SKLabelNode()
    
    override func sceneDidLoad() {
        
        let frameBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        frameBorder.friction = 0
        frameBorder.restitution = 1
        self.physicsBody = frameBorder
        performUISetup()
        
        for node in self.children{
            if node.name == labelString {
                if let someLabel: SKLabelNode = node as? SKLabelNode {
                    GameScene.label = someLabel
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// MARK: - do initial setup


extension GameScene {
    
    func performUISetup() {
        paddleLabel = self.childNode(withName: "paddleLabel") as? SKLabelNode
        ball = self.childNode(withName: pongBallString) as? SKSpriteNode
        paddle = self.childNode(withName: paddleString) as? SKSpriteNode
        scoreLabel = self.childNode(withName: scoreLabelString) as? SKSpriteNode
        border = self.childNode(withName: borderString) as? SKSpriteNode
    }
    
    class func didTurn(dial: WKCrownSequencer, previousAmount: Double) {
        //TODO: - wrap label in a physics body
    }
    
    class func moveNodeBy(who: SKNode, amount: CGFloat) {
        let move: SKAction = SKAction.moveBy(x: amount, y: 0, duration: 0.1)
        move.timingMode = .easeOut
        who.run(move)
    }
    //TO
//    func wrapLabelWithPhysics() {
//        let physicsBody = SKPhysicsBody.
//        SKLabelNode
//        }
//    
}

