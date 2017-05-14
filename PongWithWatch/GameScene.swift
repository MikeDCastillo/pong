//
//  GameScene.swift
//  PongWithWatch
//
//  Created by Michael Castillo on 4/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import SpriteKit
import GameplayKit
import SceneKit

class GameScene: SKScene {
    
    fileprivate var ball: SKSpriteNode?
    fileprivate var mainPaddle: SKSpriteNode?
    fileprivate var goalie: SKSpriteNode?
    fileprivate var continousTimer: Timer?
    fileprivate var goalieBox: SKSpriteNode?
    fileprivate var transparentGoalieBoxNode: SKSpriteNode?
    fileprivate var backgroundMusic: SKAudioNode?
    
    fileprivate let ballString = "ball"
    fileprivate let mainMovingGoalString = "mainMovingBrick"
    fileprivate let mainPaddleString = "mainPaddle"
    fileprivate let transparentSpriteKitBoxString = "transparentSpriteKitBox"
    fileprivate let mainMovingBrickBoxString = "mainMovingBrickBox"
    fileprivate let cornerBumperUpperLeftString = "cornerBumperUpperLeft"
    fileprivate let cornerBumperUpperRightString = "cornerBumperUpperRight"
    fileprivate var isPaddleBeingTouched = true

}

// MARK: - LifeCycle Func


extension GameScene {
    
    override func didMove(to view: SKView) {
        
        setupGoalConstraints()
        setupUIWithSKNodes()
        ball?.physicsBody?.applyImpulse(CGVector(dx: 15, dy: 20))
        moveGoalToRight()
        animateBackgroundWithDots()
        playMusic()
        setupFrameOrBoundsBorderPhysics()

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveGoalToAndFromBall()
    }
    
}

// MARK: - Touches Functions


extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for touch in touches {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        guard let body = physicsWorld.body(at: touchLocation) else { return }
        if body.node?.name == mainPaddleString {
            isPaddleBeingTouched = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaddleBeingTouched {
            guard let touch = touches.first else { return }
            guard let paddle = mainPaddle else { return }
            
            let touchLocation = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            _ = frame.size.width
    
            print(paddleX)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPaddleBeingTouched = false
    }
    
}

// MARK: - Goalie Logic


extension GameScene {
    
    func moveGoalToAndFromBall() {
        // This function moves the movingGoal based on the ball's Y position
        guard  let movingGoal = goalie else { return }
        guard let ball = ball else { return }
        
        movingGoal.run(SKAction.moveTo(y: ball.position.y, duration: 0.75))
    }
    
    //FIXME: - fix these
    func setupGoalConstraints () {
        guard let movingGoal = goalie else { return }
        let xRange = SKRange(lowerLimit: frame.minX, upperLimit: frame.maxX)
        let xConstraint = SKConstraint.positionX(xRange)
        let yRange = SKRange(lowerLimit: frame.midY/6, upperLimit: frame.maxY/6)
        let yConstraint = SKConstraint.positionY(yRange)
        
        movingGoal.constraints = [xConstraint, yConstraint]
    }

    // this func only took me forever to figure out, runs the paddle the right
    func moveGoalToRight() {
        guard let movingGoal = goalie else { return }
        let rightMove = SKAction.moveBy(x: 50, y: 0, duration: 3)
        movingGoal.run(rightMove)
        let sequence = SKAction.sequence([rightMove, rightMove])
        let repeatedlyRight = SKAction.repeatForever(sequence)
        movingGoal.run(repeatedlyRight)
    }
    
}


// MARK: - Setup UI with SKNodes, background, and music

extension GameScene {
    
    func setupUIWithSKNodes () {
        ball = self.childNode(withName: ballString) as? SKSpriteNode
        goalie = self.childNode(withName: mainMovingGoalString) as? SKSpriteNode
        mainPaddle = self.childNode(withName: mainPaddleString) as? SKSpriteNode
        goalieBox = self.childNode(withName: mainMovingBrickBoxString) as? SKSpriteNode
        transparentGoalieBoxNode = self.childNode(withName: transparentSpriteKitBoxString) as? SKSpriteNode
    }
    
    func animateBackgroundWithDots() {
        self.backgroundColor = UIColor.black
        guard let path = Bundle.main.path(forResource: "magic", ofType: "sks") else { print("no SKParticle path"); return }
        guard let magicParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SKEmitterNode else { return }
        magicParticle.name = "magic"
        self.addChild(magicParticle)
    }
    
    func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "CountUp", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic!)
        }
    }
    
    func setupFrameOrBoundsBorderPhysics() {
        let borderPhysicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        borderPhysicsBody.isDynamic = false
        borderPhysicsBody.allowsRotation = false
        borderPhysicsBody.affectedByGravity = false
        borderPhysicsBody.pinned = false
        borderPhysicsBody.friction = 0.0
        borderPhysicsBody.restitution = 1.0
        borderPhysicsBody.linearDamping = 0.0
        borderPhysicsBody.angularDamping = 0.0
        physicsBody = borderPhysicsBody
    }
    
}


// MARK: - Bit Masks For collisions

extension GameScene {

    enum CollisionCategory: UInt32 {
        case ball = 1
        //0
        case paddle = 2
        // (1 << 0)
        case goalie = 4
        // (1 << 1)
        case goalieBox = 8
        // (1 << 2)
        case brick = 16
        // (1 << 4)
    }
    
}
