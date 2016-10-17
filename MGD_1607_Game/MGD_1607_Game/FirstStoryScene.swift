//
//  FirstStoryScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  IAD 1608 Game Project

import UIKit
import SpriteKit


var storyNum = 0


class FirstStoryScene: SKScene {
    
    var storyLabel:SKLabelNode!
    var storyLabelSecond:SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        storyLabel = self.childNodeWithName("storyLabel") as! SKLabelNode
        storyLabelSecond = self.childNodeWithName("storyLabelSecond") as! SKLabelNode
        
        storyLabelSecond.text = "Tap the screen to get started."
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (storyNum == 0){
            
            storyLabel.text = "I heard you are wanting to skydive for us?"
            storyLabelSecond.text = ""
            storyNum = 1
            
        } else if ( storyNum == 1){
            
            storyLabel.text = "We didn't have any openings until today."
            storyNum = 2
            
        } else if ( storyNum == 2){
            
            storyLabel.text = "A guy yesterday hit a collision canyon wall."
            storyNum = 3
            
        } else if ( storyNum == 3){
            
            storyLabel.text = "Good news, now we have an opening!"
            storyNum = 4
            
        } else if ( storyNum == 4){
            
            storyLabel.text = "Are you willing to give it a shot?"
            storyNum = 5
            
        } else if ( storyNum == 5){
            
            storyLabel.text = "Tap the screen one more time to get started!"
            storyNum = 6
            
        } else if ( storyNum == 6){
            
            let gameScene:GameScene = GameScene(fileNamed: "GameScene")!
            gameScene.scaleMode = .AspectFit
            self.view?.presentScene(gameScene)
        }
    }
}
