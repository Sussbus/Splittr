//
//  GameScene.swift
//  Splittr
//
//  Created by Jocelyn Sussman on 11/14/16.
//  Copyright © 2016 Jacob Sussman. All rights reserved.
//

import SpriteKit
import GameplayKit
import EasyImagy

class GameScene: SKScene, SKPhysicsContactDelegate {
    
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
    
    //Declaring Nodes
    var ball1 = SKSpriteNode()
    var ball2 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var conerParticles = SKEffectNode()
    
    var shapePattern = SKSpriteNode();
    var pixelValues: Image<RGBA>?;
    
    //Timer
    func keepScore() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        //Setting Up Physics
        physicsWorld.contactDelegate = self
        
        ball1 = self.childNode(withName: "Ball1") as! SKSpriteNode
        ball2 = self.childNode(withName: "Ball2") as! SKSpriteNode
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
                ball1.run(SKAction.moveTo(x: -(CGFloat)(splitDistance), duration: 0.2))
                ball2.run(SKAction.moveTo(x: CGFloat(splitDistance), duration: 0.2))
            }
            
            //Checks if balls are split
            isSplit = ball1.position.x < 0 && splittingEnabled
            
            //Moves Ball from right to left if not split
            if !splittingEnabled {
                ball1.run(SKAction.moveTo(x: (CGFloat)(location.x), duration: 0.15))
                ball2.run(SKAction.moveTo(x: (CGFloat)(location.x), duration: 0.15))
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
        shapePattern = SKSpriteNode(imageNamed: "ShapePattern\(patternNumber)")
        shapePattern.name = "shapePattern\(patternNumber)"
        shapePattern.position = CGPoint(x: 0, y: shapePattern.size.height)
        let moveShape = SKAction.moveTo(y: -2000, duration: TimeInterval(patternSpeed))
        let removeShape = SKAction.removeFromParent()
        shapePattern.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(shapePattern)
        
        let patternImage = shapePattern.texture?.cgImage()
        pixelValues = Image<RGBA>(cgImage: patternImage!)
    }
    
    //Centers the ball to the middle of the screen
    func centerBalls() {
        if ball1.position.x < 0 || ball2.position.x > 0 {
            ball1.run(SKAction.moveTo(x: 0, duration: 0.2))
            ball2.run(SKAction.moveTo(x: 0, duration: 0.2))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        centerBalls()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        centerBalls()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        //print(ball1.position)
        checkCollisions(ball: ball1)
        //checkCollisions(ball: ball2)
    }

    func checkCollisions(ball: SKSpriteNode) {
        
        let posX = Int(ball.position.x)
        let posY = Int(ball.position.y)
        
        // Loop around each point of the ball
        var x = posX
        var y = posY + Int(ball.size.height / 2)
        
        var xMult = 1
        var yMult = -1
        
        while (true) {
            // these are the coordinates of each point of the ball
            
            x = x + xMult
            y = y + yMult
            
            //we need to convert the coordinates to the coordinates of the background pattern array
            //not yet finished
            let imageX = ((view?.bounds.height)! / 2 + CGFloat(x))*2
            let imageY = ((view?.bounds.height)! / 2 + CGFloat(y))*2
            
            //print(view?.bounds.height)
            //print("\(imageX), \(imageY)")
            if let pixel = pixelValues?.pixel(Int(imageX), Int(imageY)) {
                //print(pixel)
            }
            
            if (y == posY && x == posX + Int(ball.size.width / 2)) {
                xMult = -1
                yMult = -1
            } else if(x == posX && y == posY - Int(ball.size.height / 2)) {
                xMult = -1
                yMult = 1
            } else if(y == posY && x == posX - Int(ball.size.width / 2)) {
                xMult = 1
                yMult = 1
            }
            
            if (x == posX && y >= posY + Int(ball.size.height / 2)) {
                break
            }
        }
    }
    
}




