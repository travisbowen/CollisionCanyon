//
//  CreditScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  MGD 1607 Game Project

import UIKit
import SpriteKit

class CreditScene: SKScene {
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            let gameScene:MainScene = MainScene(fileNamed: "MainScene")!
            gameScene.scaleMode = .AspectFit
            self.view?.presentScene(gameScene)
    }
}
