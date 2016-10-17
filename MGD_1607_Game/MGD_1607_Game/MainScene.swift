//
//  MainScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  MGD 1607 Game Project

import UIKit
import SpriteKit



class MainScene: SKScene {
    
    var playLabel:SKLabelNode!
    var InstructionsLabel:SKLabelNode!
    var creditsLabel:SKLabelNode!
    
    
    override func didMoveToView(view: SKView) {
        
        playLabel = self.childNodeWithName("play_label") as! SKLabelNode
        InstructionsLabel = self.childNodeWithName("instructions_label") as! SKLabelNode
        creditsLabel = self.childNodeWithName("credits_label") as! SKLabelNode
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //Called when a user touches a sprite
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            if let theName = self.nodeAtPoint(location).name {
                
                switch theName {
                case "play_label":
                    let gameScene:FirstStoryScene = FirstStoryScene(fileNamed: "FirstStoryScene")!
                    gameScene.scaleMode = .AspectFit
                    self.view?.presentScene(gameScene)
                    
                case "instructions_label":
                    let gameScene:InstructionsScene = InstructionsScene(fileNamed: "InstructionsScene")!
                    gameScene.scaleMode = .AspectFit
                    self.view?.presentScene(gameScene)
                    
                case "credits_label":
                    let gameScene:CreditScene = CreditScene(fileNamed: "CreditScene")!
                    gameScene.scaleMode = .AspectFit
                    self.view?.presentScene(gameScene)
                    
                default: break
                    
                }
            }
        }
    }
}
