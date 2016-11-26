//
//  GameScene.swift
//  Splittr
//
//  Created by Jocelyn Sussman on 11/14/16.
//  Copyright © 2016 Jacob Sussman. All rights reserved.
//

import SpriteKit
import GameplayKit

//Constants

// TODO: Dynamically calculate based on screen size
let SPLIT_MULTIPLIER = 50
let SPLIT_MAX = 500
let PATTERN_DELAY = 7
let PATTERN_PROPERTIES = [
    [
        "splittingEnabled": true
    ],
    [
        "splittingEnabled": false
    ],
    [
        "splittingEnabled": true
    ]
]

//Variables
var splittingEnabled = true
var isSplit = false
var score = 0
var patternSpeed = 10

class GameScene: SKScene, SKPhysicsContactDelegate {

    //Declaring Nodes
    var Ball1 = SKSpriteNode()
    var Ball2 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var conerParticles = SKEffectNode()
    
    //Timer
    func keepScore() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            score += 1
            self.scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        //Setting Up Physics
        physicsWorld.contactDelegate = self
        
        Ball1 = self.childNode(withName: "Ball1") as! SKSpriteNode
        Ball2 = self.childNode(withName: "Ball2") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        
        //Corner Particles
        if let particles = SKEmitterNode(fileNamed: "Trail") {
            particles.position = CGPoint(x: -200, y: 400)
            addChild(particles)
        }
        
        
        //Spawns pattern after a delay
        let delay = SKAction.wait(forDuration: TimeInterval(PATTERN_DELAY))
        
        let spawnShapes = SKAction.run({
            () in
            self.choosePattern()
        })
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawnShapes, delay])))
        
        self.keepScore()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //splittingEnabled = true
            let touchForce = touch.force
            let location = touch.location(in: self)
            let splitDistance = min(max(Int(touchForce * CGFloat(SPLIT_MULTIPLIER)), 0), SPLIT_MAX)
            
            if splittingEnabled {
                Ball1.run(SKAction.moveTo(x: -(CGFloat)(splitDistance), duration: 0.2))
                Ball2.run(SKAction.moveTo(x: CGFloat(splitDistance), duration: 0.2))
            }
            
            //Checks if balls are split
            isSplit = Ball1.position.x < 0 && splittingEnabled
            
            //Moves Ball from right to left if not split
            if !splittingEnabled {
                Ball1.run(SKAction.moveTo(x: (CGFloat)(location.x), duration: 0.15))
                Ball2.run(SKAction.moveTo(x: (CGFloat)(location.x), duration: 0.15))
            }
        }
    }
    
    //Chooses Random Pattern To Spawn
    func choosePattern() {
        let randNumber = Int(arc4random_uniform(UInt32(PATTERN_PROPERTIES.count)))
        spawnPattern(patternNumber: randNumber)
    }
    
    //Spawns a pattern based on its pattern number
    func spawnPattern(patternNumber: Int) {
        splittingEnabled = PATTERN_PROPERTIES[patternNumber]["splittingEnabled"]!
        let shapePattern = SKSpriteNode(imageNamed: "ShapePattern\(patternNumber)")
        shapePattern.name = "shapePattern\(patternNumber)"
        shapePattern.position = CGPoint(x: 0, y: shapePattern.size.height)
        let moveShape = SKAction.moveTo(y: -2000, duration: TimeInterval(patternSpeed))
        let removeShape = SKAction.removeFromParent()
        shapePattern.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(shapePattern)
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

    
}




