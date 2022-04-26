//
//  GameScene.swift
//  pxnGame
//
//  Created by Brandon Kim on 4/8/22.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var livesNumber = 3
    
    
    
    
    
    
    
    
    var gameArea:CGRect
    
    enum gameState {
        //state machine
        case preGame //Game state is before the start of the game
        case inGame // Game state is during the game
        case afterGame // Game state is after the game
        
    }
    
    var currentGameState = gameState.inGame
    
    struct PhysicsCategories{
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 // form of binary for 1
        static let Bullet : UInt32 = 0b10 // 2
        static let Enemy : UInt32 = 0b100 // 4 (3 is for Player and Bullet)
        static let Mainframe: UInt32 = 0b0110 // 6
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max:CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    override init(size:CGSize) {
        //making playable area correct
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.width / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)


        super.init(size: size)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        var cardSpaceCon = 29.750015258789062
        
        let card1 = SKSpriteNode(imageNamed: "cardBackground")
        card1.setScale(1.3)
//      card1.size = CGSize(width: (self.size.width / 3) - 30, height: (self.size.height / 4) - 20)
//      card1.position = CGPoint(x: self.size.width / 3 - 60, y: self.size.height / 6)
        card1.position = CGPoint(x: 0 + card1.size.width * 1.5 + cardSpaceCon, y: self.size.height / 6)
        card1.zPosition = 1
        self.addChild(card1)
        
       
        
        let card2 = SKSpriteNode(imageNamed: "cardBackground")
        card2.setScale(1.3)
        card2.position = CGPoint(x: self.size.width / 2, y: self.size.height / 6)
        card2.zPosition = 1
        self.addChild(card2)
        
        
        
        
        
        
        let card3 = SKSpriteNode(imageNamed: "cardBackground")
        var cardWidth = card3.size.width
        card3.setScale(1.3)
        card3.position = CGPoint(x: (self.size.width / 2) + (card3.size.width) + cardSpaceCon, y: self.size.height / 6)
        card3.zPosition = 1
        self.addChild(card3)
        
        
    }
    
    
  
    

  
       
        
        
    
    
   
   
    
    
    
    
        
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        if currentGameState == gameState.preGame {
//            startGame()
//        } else if currentGameState == gameState.inGame {
//            fireBullet()
//        }
//
        
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
//            let pointOfTouch = touch.location(in: self)
//            let previousPointOfTouch = touch.previousLocation(in: self)
//
//            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                
            }
     
            
            //makes sprite disappear
//            if (player.position.x > gameArea.maxX - player.size.width/(5*2) ) {
//                player.setScale(0.2)
//                player.zPosition = 2
//                player.position.x = gameArea.maxX - player.size.width/(5*2)
//
//
//            }
//
//            if (player.position.x < gameArea.maxX + player.size.width/(5*2) ) {
//                player.setScale(0.2)
//                player.zPosition = 2
//                player.position.x = gameArea.maxX + player.size.width/(5*2)
//            }
            
            
        }
    }
    
    
}
