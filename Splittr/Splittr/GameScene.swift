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
var shapeCount:Int = 2
var score = 0
var scoresRunning = false
var patternSpeed = 10

class GameScene: SKScene, SKPhysicsContactDelegate {

    //Starts The Score
    var scoresRunning = true
    
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
            //print(score)
        }
    }
    
    override func didMove(to view: SKView) {
        
        //Setting Up Physics
        physicsWorld.contactDelegate = self
        
        //Naming Sprites
        Ball1 = self.childNode(withName: "Ball1") as! SKSpriteNode
        Ball1.name = "Ball1"
        Ball2 = self.childNode(withName: "Ball2") as! SKSpriteNode
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
            var splitDistance = Int(touchForce * SPLIT_MULTIPLIER)
            
            
            if splitDistance < 0 {
                splitDistance = 0
            }
        
            if splitDistance > SPLIT_MAX {
                splitDistance = SPLIT_MAX
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
    
    //Chooses Random Pattern To Spawn
    func chooseShape() {
        let randNumber = Int(arc4random_uniform(UInt32(PATTERN_PROPERTIES.count)))
        spawnShape(patternNumber: randNumber)
    }
    
    //Spawns a shape based on its pattern number
    func spawnShape(patternNumber: Int) {
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




