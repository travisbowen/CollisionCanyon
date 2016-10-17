//
//  SecondStoryScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  IAD 1608 Game Project

import UIKit
import SpriteKit

var storyNumTwo = 0

class SecondStoryScene: SKScene {
    
    var storyLabelTwo:SKLabelNode!
    
    
    override func didMoveToView(view: SKView) {
        storyLabelTwo = self.childNodeWithName("storyLabelTwo") as! SKLabelNode
        storyLabelTwo.text = "You actually completed the jump?"
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (storyNumTwo == 0){
            
            storyLabelTwo.text = "That wasn't your first time jumping was it?"
            storyNumTwo = 1
            
        } else if ( storyNumTwo == 1){
            
            storyLabelTwo.text = "Well... uhhh... congratulations!"
            storyNumTwo = 2
            
        } else if ( storyNumTwo == 2){
            
            storyLabelTwo.text = "You're hired on as our new skydiver."
            storyNumTwo = 3
            
        } else if ( storyNumTwo == 3){
            
            storyLabelTwo.text = "Tap the screen to get to the main menu."
            storyNumTwo = 4
            
        } else if ( storyNumTwo == 4){
            
            let gameScene:MainScene = MainScene(fileNamed: "MainScene")!
            gameScene.scaleMode = .AspectFit
            self.view?.presentScene(gameScene)
        } 
    }
}
