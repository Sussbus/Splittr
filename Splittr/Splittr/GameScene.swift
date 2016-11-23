//
//  GameScene.swift
//  Splittr
//
//  Created by Jocelyn Sussman on 11/14/16.
//  Copyright © 2016 Jacob Sussman. All rights reserved.
//

import SpriteKit
import GameplayKit
//Creating Physics

    //Variables
    var splittingEnabled = true
    var isSplit = false
    var shapeCount:Int = 2
    var patternSpeed = TimeInterval(10)
    var score = 0
    var scoresRunning = false


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let BallCategory: UInt32 = 0x1 << 0
    let ShapePatternCategory: UInt32 = 0x1 << 1

    //Starts The Score
    var scoresRunning = true
    
    //Declaring Nodes
    var Ball1 = SKSpriteNode()
    var Ball2 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var ShapePattern1 = SKSpriteNode()
    var conerParticles = SKEffectNode()
    
    //Timer
    func keepScore() {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
    score = score + 1
    let scoreLabelText = "Score: " + String(score)
    self.scoreLabel.text = scoreLabelText
    //print(score)
        }
    }
    override func didMove(to view: SKView) {
        
        
        //Setting Up Physics
        physicsWorld.contactDelegate = self
        
        //Naming Sprites
        Ball1 = self.childNode(withName: "Ball1") as! SKSpriteNode
        Ball1.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        Ball1.physicsBody?.isDynamic = false
        Ball1.physicsBody?.affectedByGravity = false
        Ball1.physicsBody?.categoryBitMask = BallCategory
        Ball1.physicsBody?.collisionBitMask = 0
        Ball1.name = "Ball1"
        Ball2 = self.childNode(withName: "Ball2") as! SKSpriteNode
        Ball2.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        Ball2.physicsBody?.isDynamic = false
        Ball2.physicsBody?.affectedByGravity = false
        Ball2.physicsBody?.categoryBitMask = BallCategory
        Ball2.physicsBody?.collisionBitMask = 0
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        //2ShapePattern1 = self.childNode(withName: "ShapePattern1") as! SKSpriteNode
        
        //Corner Particles
        if let particles = SKEmitterNode(fileNamed: "Trail") {
            particles.position = CGPoint(x: -200, y: 400)
            addChild(particles)
        }
        //Spawns Pattern Every
        let delay = SKAction.wait(forDuration: 7)
        //Spawns Shapes Every 3 Seconds
        let spawnShapes = SKAction.run({
            () in
            self.chooseShape()
            
        })
        
        var spawnAndDelay = SKAction.sequence([spawnShapes, delay])
        spawnAndDelay = SKAction.repeatForever(spawnAndDelay)
        self.run(spawnAndDelay)
        let keepScore = SKAction.run({
            () in
            self.keepScore()
            
        })
        self.run(keepScore)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

            
        
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            //splittingEnabled = true
            let touchForce = touch.force
            let location = touch.location(in: self)
            var splitDistance = Int(touchForce * 50)
            
            
            if splitDistance < 0 {
                splitDistance = 0
            }
            if splitDistance > 500 {
                splitDistance = 500
            }
            
            if splittingEnabled == true {
            Ball1.run(SKAction.moveTo(x: -(CGFloat)(splitDistance), duration: 0.2))
            Ball2.run(SKAction.moveTo(x: CGFloat(splitDistance), duration: 0.2))
            }
            //Checks if balls are split
            if Ball1.position.x < 0 && splittingEnabled == true {
                    isSplit = true
            }
            else {
                isSplit = false
            }
            
            //Moves Ball from right to left if not split
            let slidePosition = location.x
            
            if splittingEnabled == false {
                Ball1.run(SKAction.moveTo(x: (CGFloat)(slidePosition), duration: 0.15))
                Ball2.run(SKAction.moveTo(x: (CGFloat)(slidePosition), duration: 0.15))
            }
            //print(splitDistance)
            
        }
        
    
        
    }


    
    //Spawn Shapes
    func spawnShapePattern1() -> SKSpriteNode {
        splittingEnabled = true
        let ShapePattern1 = SKSpriteNode(imageNamed: "ShapePattern1")
        //Physics Attributes
        ShapePattern1.physicsBody = SKPhysicsBody(rectangleOf: ShapePattern1.size)
        ShapePattern1.physicsBody?.isDynamic = false
        ShapePattern1.physicsBody?.affectedByGravity = false
        ShapePattern1.name = "shapePattern1"
        ShapePattern1.physicsBody?.categoryBitMask = ShapePatternCategory
        ShapePattern1.physicsBody?.usesPreciseCollisionDetection = true
        ShapePattern1.physicsBody?.contactTestBitMask = BallCategory
        ShapePattern1.physicsBody?.collisionBitMask = 1
        
        ShapePattern1.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern1.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern1)
        sequence
        return ShapePattern1
    }
    
    func spawnShapePattern2() -> SKSpriteNode {
        splittingEnabled = false
        let ShapePattern2 = SKSpriteNode(imageNamed: "ShapePattern2")
        //Physics Attributes
        ShapePattern2.physicsBody = SKPhysicsBody(rectangleOf: ShapePattern2.size)
        ShapePattern2.physicsBody?.isDynamic = false
        ShapePattern2.physicsBody?.affectedByGravity = false
        ShapePattern2.name = "shapePattern2"
        ShapePattern2.physicsBody?.categoryBitMask = ShapePatternCategory
        ShapePattern2.physicsBody?.usesPreciseCollisionDetection = true
        ShapePattern2.physicsBody?.contactTestBitMask = BallCategory
        ShapePattern2.physicsBody?.collisionBitMask = 1
        
        ShapePattern2.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern2.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern2)
        sequence
        return ShapePattern2
    }
    
    func spawnShapePattern3() -> SKSpriteNode {
        splittingEnabled = true
        let ShapePattern3 = SKSpriteNode(imageNamed: "ShapePattern3")
        //Physics Attributes
        ShapePattern3.physicsBody = SKPhysicsBody(rectangleOf: ShapePattern3.size)
        ShapePattern3.physicsBody?.isDynamic = false
        ShapePattern3.physicsBody?.affectedByGravity = false
        ShapePattern3.name = "shapePattern3"
        ShapePattern3.physicsBody?.categoryBitMask = ShapePatternCategory
        ShapePattern3.physicsBody?.usesPreciseCollisionDetection = true
        ShapePattern3.physicsBody?.contactTestBitMask = BallCategory
        ShapePattern3.physicsBody?.collisionBitMask = 1
        
        ShapePattern3.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern3.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern3)
        sequence
        return ShapePattern3
    }
    
    //Chooses Random Pattern To Spawn
    func chooseShape() {
        
        shapeCount = 3
        let randNumber = Int(arc4random_uniform(UInt32(shapeCount)) + 1)
        //print(randNumber)
        if randNumber == 1 {
            spawnShapePattern1()
        }
        else if randNumber == 2 {
            spawnShapePattern2()
        }
        else if randNumber == 3 {
            spawnShapePattern3()
        }
    }
    
    //Centers the ball to the middle of the screen
    func centerBalls() {
        if Ball1.position.x < 0 || Ball2.position.x > 0 {
            
            Ball1.run(SKAction.moveTo(x: 0, duration: 0.2))
            Ball2.run(SKAction.moveTo(x: 0, duration: 0.2))
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        centerBalls()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            centerBalls()
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        }


    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "Ball1" {
            print("hit")
        }
        if contact.bodyA.node?.name == "ShapePattern1" {
            print("hit")
        }
    }
    
}




