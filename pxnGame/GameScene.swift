//
//  GameScene.swift
//  pxnGame
//
//  Created by Brandon Kim on 4/8/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "rei3")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(0.2)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        player.zPosition = 2
        self.addChild(player)
        
        let mainframe = SKSpriteNode(imageNamed: "mainframe3")
        mainframe.setScale(1)
        mainframe.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0)
        mainframe.zPosition = 2
        self.addChild(mainframe)
        
//        let bullet = SKSpriteNode(imageNamed: "ghost")
//        bullet.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
//        bullet.zPosition = 1
//        bullet.setScale(0.3)
//        self.addChild(bullet)
        
        
        
    }
    
    
    func fireBullet() {
        let bullet  = SKSpriteNode(imageNamed: "ghost")
        bullet.setScale(0.3)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet,deleteBullet])
        bullet.run(bulletSequence)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
            
        }
    }
    
    
}
