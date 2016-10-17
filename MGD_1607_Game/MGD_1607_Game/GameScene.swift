//
//  GameScene.swift
//  MGD_1607_Game
//
//  Travis Bowen
//  MGD 1607 Game Project

import SpriteKit
import AVFoundation
import GameKit

let skyDiverMask:UInt32 = 0x1 << 0 //1
let wallMask:UInt32 = 0x1 << 1 //2
let parachuteMask:UInt32 = 0x1 << 2 //4
let backgroundMask:UInt32 = 0x1 << 3 //8
var isPaused = false
var score = 0
var scoreString = String(score)
var userDied = false
var userTry = 0

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    var scoreLabel:SKLabelNode!
    var parachute:SKSpriteNode!
    var skyDiver:SKSpriteNode!
    var buttonAbility:SKSpriteNode!
    var buttonAbilityDisabled:SKSpriteNode!
    var buttonPause:SKSpriteNode!
    var rockLeft:SKSpriteNode!
    var rockRight:SKSpriteNode!
    
    var parachuteAnimation = [SKTexture]()

    
    override func didMoveToView(view: SKView) {
        
        score = 0
        
        //Authenticate player for game center
        authPlayer()
        
        //Preloading sound effects
        preloadSounds()
        
        self.physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVectorMake(0, -0.5)
        
        
        //Scene Setup
        scoreLabel = self.childNodeWithName("score_label") as! SKLabelNode
        skyDiver = self.childNodeWithName("sky_diver") as! SKSpriteNode
        parachute = skyDiver.childNodeWithName("parachute") as! SKSpriteNode
        buttonAbility = self.childNodeWithName("ability_button") as! SKSpriteNode
        buttonAbilityDisabled = self.childNodeWithName("ability_button_disabled") as! SKSpriteNode
        buttonPause = self.childNodeWithName("pause_button") as! SKSpriteNode
        rockLeft = self.childNodeWithName("rock_left") as! SKSpriteNode
        rockRight = self.childNodeWithName("rock_right") as! SKSpriteNode
        
        parachute.hidden = true
        
        //Setting collisions and gravity for skydiver
        skyDiver.physicsBody?.collisionBitMask = wallMask
        skyDiver.physicsBody?.contactTestBitMask = skyDiver.physicsBody!.collisionBitMask
        
        
        let parachuteAtlas = SKTextureAtlas(named: "parachute")
        for index in 1...parachuteAtlas.textureNames.count{
            let imageName = String(format: "parachute%01d", index)
            parachuteAnimation += [parachuteAtlas.textureNamed(imageName)]
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       //Called when a user touches a sprite
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            if (location.x < 500){
                skyDiver.physicsBody?.applyImpulse(CGVectorMake(-30, 0))
            } else {
                skyDiver.physicsBody?.applyImpulse(CGVectorMake(30, 0))
            }
            
            if let theName = self.nodeAtPoint(location).name {
    
                switch theName {
                case "ability_button":
                    if (parachute.hidden != false){
                        parachute.hidden = false
                        buttonAbility.hidden = true
                        let animation = SKAction.animateWithTextures(parachuteAnimation, timePerFrame: 0.12)
                        parachute.runAction(animation)
                        playSound("parachute_open.mp3")
                        physicsWorld.gravity = CGVectorMake(0, -0.1)
                        
                    }
                case "pause_button":
                    if(isPaused == false){
                        scene!.view?.paused = true
                        isPaused = true
                        
                        let alert = UIAlertController(title: "Game Paused", message:
                            "", preferredStyle: UIAlertControllerStyle.Alert)
                        let action = UIAlertAction(title: "Resume", style: .Default) { _ in
                            self.scene!.view?.paused = false
                            isPaused = false
                        }
                        alert.addAction(action)
                        self.view?.window?.rootViewController?.presentViewController(alert, animated: true){}
                    }
                default: break
                    
                }
            }
        }
    }
   
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if (skyDiver.position.y > 0 && userDied == false){
            score = score + 10
            scoreString = String(score)
            scoreLabel.text = "Score: " + scoreString
        }
        
        if (skyDiver.position.y < 0){
            
            self.scene!.view?.paused = true
            
            //Calling function to save the score to game center
            saveScore(score)
            
            //Calling function to unlock completion achievement
            unlockAchievement("Achievement_Complete", percentage: 100)
            
            if (score >= 1000){
                //Calling function to unlock gold achievement
                unlockAchievement("Achievement_Gold", percentage: 100)
            }
            
            let alert = UIAlertController(title: "You Won!", message:
                "Your score was " + scoreString + "!", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Main Menu", style: .Default) { _ in
                
                let gameScene:SecondStoryScene = SecondStoryScene(fileNamed: "SecondStoryScene")!
                gameScene.scaleMode = .AspectFit
                self.view?.presentScene(gameScene)
            }
            
            let action2 = UIAlertAction(title: "Show Leaderboard", style: .Default) { _ in
                
                self.showBoard()
                let gameScene:SecondStoryScene = SecondStoryScene(fileNamed: "SecondStoryScene")!
                gameScene.scaleMode = .AspectFit
                self.view?.presentScene(gameScene)
            }
            alert.addAction(action)
            alert.addAction(action2)
            self.view?.window?.rootViewController?.presentViewController(alert, animated: true){}
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        playSound("wall_hit.mp3")
        playSound("ow.mp3")
        skyDiver.removeFromParent()
        userDied = true
        
        userTry += 1
        
        if (userTry == 3){
            //Calling function to unlock luck achievement
            unlockAchievement("Achievement_Luck", percentage: 100)
        }
        
        //Calling function to unlock death achievement
        unlockAchievement("Achievement_Death", percentage: 100)
        
        let alert = UIAlertController(title: "You Died", message:
            "Your score was " + scoreString + "!", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Main Menu", style: .Default) { _ in
            
            let gameScene:MainScene = MainScene(fileNamed: "MainScene")!
            gameScene.scaleMode = .AspectFit
            self.view?.presentScene(gameScene)
        }
        alert.addAction(action)
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true){}
    }
    
    
    //Function to preload the sounds
    func preloadSounds(){
        do {
            let soundEffects = ["parachute_open", "ow", "wall_hit"]
            for sound in soundEffects {
                let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!))
                player.prepareToPlay()
            }
        } catch {
            print("Preload Sound Error")
        }
    }
    
    
    //Function to play the sounds
    func playSound(songName: String){
        self.runAction(SKAction.playSoundFileNamed(songName, waitForCompletion: true))
    }
    
    
    //Function to auth game center
    func authPlayer(){
        
        let player = GKLocalPlayer.localPlayer()
        
        player.authenticateHandler = {
            (view, error) in
            
            if (view != nil){
                self.view?.window?.rootViewController?.presentViewController(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.localPlayer().authenticated)
            }
        }
    }
    
    
    //Function to save score in game center
    func saveScore(score : Int){
        
        if (GKLocalPlayer.localPlayer().authenticated){
            
            //Saving to the leaderboard
            let scoreSaver = GKScore(leaderboardIdentifier: "CCLB")
            
            scoreSaver.value = Int64(score)
            
            let arrayOfScores : [GKScore] = [scoreSaver]
            
            GKScore.reportScores(arrayOfScores, withCompletionHandler: nil)
        }
    }
    
    
    //Function to show leaderboard
    func showBoard(){
        
        let vc = self.view?.window?.rootViewController
        
        let gameCenterVC = GKGameCenterViewController()
        
        gameCenterVC.gameCenterDelegate = self
        
        vc?.presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func unlockAchievement(identifier : String, percentage : Double){
        
        if (GKLocalPlayer.localPlayer().authenticated){
            
            let achievement = GKAchievement(identifier: identifier)
            
            achievement.percentComplete = percentage
            achievement.showsCompletionBanner = true
            
            GKAchievement.reportAchievements([achievement], withCompletionHandler: nil)
        }
    }
}
