//
//  InstructionsScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  MGD 1607 Game Project

import UIKit
import SpriteKit

class InstructionsScene: SKScene {
    
    var instructionBackground:SKSpriteNode!
    
    
    override func didMoveToView(view: SKView) {
        
        //Scene Setup
        instructionBackground = self.childNodeWithName("instruction_background") as! SKSpriteNode
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //Called when a user touches a sprite
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            if let theName = self.nodeAtPoint(location).name {
                
                if(theName == "instruction_background"){
                    let gameScene:MainScene = MainScene(fileNamed: "MainScene")!
                    gameScene.scaleMode = .AspectFit
                    self.view?.presentScene(gameScene)
                }
            }
        }
    }
}
