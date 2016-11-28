//
//  GameScene.swift
//  BlockDodge
//
//  Created by Jacob Sussman on 11/10/16.
//  Copyright © 2016 Luke Rose. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    
    //Declaring Sprites
    var playButton = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        playButton = self.childNode(withName: "playButton") as! SKLabelNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let gameSceneMain = GameScene(fileNamed: "GameScene")
            gameSceneMain!.scaleMode = .aspectFill
            let transition = SKTransition.moveIn(with: .down, duration: 1.0)
            let location = touch.location(in: self)
            if playButton.contains(location) {
                self.scene?.view?.presentScene(gameSceneMain!, transition: transition)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
}
