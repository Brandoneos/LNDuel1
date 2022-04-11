//
//  GameOverScene.swift
//  pxnGame
//
//  Created by Brandon Kim on 4/10/22.
//

import Foundation
import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    let restartLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode()
        background.color = .red
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontName = "American Typewriter Bold"
        gameOverLabel.fontSize = 160
        gameOverLabel.fontColor = SKColor.black
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode()
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontName = "American Typewriter Bold"
        scoreLabel.fontColor = SKColor.green
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults.standard
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode()
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontName = "American Typewriter Bold"
        highScoreLabel.fontColor = SKColor.green
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        
        restartLabel.text = "Restart"
        restartLabel.fontName = "American Typewriter Bold"
        restartLabel.fontSize = 120
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //making the restart label act as a button
        for touch: AnyObject in touches {
            
            let pointofTouch = touch.location(in: self)
            
            if restartLabel.contains(pointofTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo,transition: transition)
                
            }
        }
    }
}







