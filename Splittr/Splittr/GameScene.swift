//
//  GameScene.swift
//  Splittr
//
//  Created by Jocelyn Sussman on 11/14/16.
//  Copyright © 2016 Jacob Sussman. All rights reserved.
//

import SpriteKit
import GameplayKit

    //Variables
    var splittingEnabled = true
    var isSplit = false
    var shapeCount:Int = 2
    var patternSpeed = TimeInterval(10)

class GameScene: SKScene {
    
    //Declaring Nodes
    var Ball1 = SKSpriteNode()
    var Ball2 = SKSpriteNode()
    var ShapePattern1 = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        Ball1 = self.childNode(withName: "Ball1") as! SKSpriteNode
        Ball2 = self.childNode(withName: "Ball2") as! SKSpriteNode
        //2ShapePattern1 = self.childNode(withName: "ShapePattern1") as! SKSpriteNode
        
        
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
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches {
            
        }
        
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
            print(splitDistance)
            
        }
        
    
        
    }
    
    
    //Spawn Shapes
    func spawnShapePattern1() {
        splittingEnabled = true
        let ShapePattern1 = SKSpriteNode(imageNamed: "ShapePattern1")
        ShapePattern1.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern1.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern1)
        sequence
    }
    func spawnShapePattern2() {
        splittingEnabled = false
        let ShapePattern2 = SKSpriteNode(imageNamed: "ShapePattern2")
        ShapePattern2.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern2.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern2)
        sequence
    }
    
    func spawnShapePattern3() {
        splittingEnabled = true
        let ShapePattern3 = SKSpriteNode(imageNamed: "ShapePattern3")
        ShapePattern3.position = CGPoint(x: 0, y: 1334)
        let moveShape = SKAction.moveTo(y: -2000, duration: patternSpeed)
        let removeShape = SKAction.removeFromParent()
        let sequence = ShapePattern3.run(SKAction.sequence([moveShape, removeShape]))
        self.addChild(ShapePattern3)
        sequence
    }
    
    //Chooses Random Pattern To Spawn
    func chooseShape() {
        
        shapeCount = 3
        let randNumber = Int(arc4random_uniform(UInt32(shapeCount)) + 1)
        print(randNumber)
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
}
