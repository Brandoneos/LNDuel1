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
    
    let Nlabel1 = SKLabelNode()
    let Llabel1 = SKLabelNode()
    let Nlabel2 = SKLabelNode()
    let Llabel2 = SKLabelNode()
    let Nlabel3 = SKLabelNode()
    let Llabel3 = SKLabelNode()
    
    
    
    
    
    
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
        
        //test card
        var card0 = SKSpriteNode(imageNamed: "cardBackground")
        card0.setScale(1.3)
        var cardSpaceCon = 29.750015258789062
        var cardSpace = (((self.size.width / 2) - (card0.size.width * 1.5 + cardSpaceCon)) - card0.size.width) / 2
        var testCS = ((((self.size.width / 2) - (card0.size.width * 1.5)) - card0.size.width) / 2)
//        print(cardSpaceCon)
//        print(cardSpace)
//        print(testCS)
        
        //Player Cards
        
        let card1 = SKSpriteNode(imageNamed: "cardBackground")
        card1.setScale(1.3)
//      card1.size = CGSize(width: (self.size.width / 3) - 30, height: (self.size.height / 4) - 20)
//      card1.position = CGPoint(x: self.size.width / 3 - 60, y: self.size.height / 6)
        card1.position = CGPoint(x: 0 + card1.size.width * 1.5 + cardSpaceCon, y: self.size.height / 6.5)
        card1.zPosition = 1
        self.addChild(card1)
    
        let card2 = SKSpriteNode(imageNamed: "cardBackground")
        card2.setScale(1.3)
        card2.position = CGPoint(x: self.size.width / 2, y: self.size.height / 6.5)
        card2.zPosition = 1
        self.addChild(card2)

        let card3 = SKSpriteNode(imageNamed: "cardBackground")
        var cardWidth = card3.size.width
        card3.setScale(1.3)
        card3.position = CGPoint(x: (self.size.width / 2) + (card3.size.width) + cardSpaceCon, y: self.size.height / 6.5 )
        card3.zPosition = 1
        self.addChild(card3)
        
        //Computer // Second Player Cards
        
        let card4 = SKSpriteNode(imageNamed: "cardBackground")
        card4.setScale(1.3)
        card4.position = CGPoint(x: 0 + card4.size.width * 1.5 + cardSpaceCon, y: self.size.height / 6.5 * 5.5)
        card1.zPosition = 1
        self.addChild(card4)
    
        let card5 = SKSpriteNode(imageNamed: "cardBackground")
        card5.setScale(1.3)
        card5.position = CGPoint(x: self.size.width / 2, y: self.size.height / 6.5 * 5.5)
        card5.zPosition = 1
        self.addChild(card5)

        let card6 = SKSpriteNode(imageNamed: "cardBackground")
        card6.setScale(1.3)
        card6.position = CGPoint(x: (self.size.width / 2) + (card6.size.width) + cardSpaceCon, y: self.size.height / 6.5 * 5.5)
        card6.zPosition = 1
        self.addChild(card6)
        
        Nlabel1.text = "\(5)"
        Nlabel1.fontName = "American Typewriter Bold"
        Nlabel1.fontSize = 120
        Nlabel1.fontColor = SKColor.black
        Nlabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Nlabel1.position = CGPoint(x: card1.position.x, y: card1.position.y + card1.size.width / 4)
        Nlabel1.zPosition = 2
        self.addChild(Nlabel1)
        
        Llabel1.text = "\("A")"
        Llabel1.fontName = "American Typewriter Bold"
        Llabel1.fontSize = 120
        Llabel1.fontColor = SKColor.black
        Llabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Llabel1.position = CGPoint(x: card1.position.x, y: card1.position.y - card1.size.width / 2.2)
        Llabel1.zPosition = 2
        self.addChild(Llabel1)
        
        Nlabel2.text = "\(5)"
        Nlabel2.fontName = "American Typewriter Bold"
        Nlabel2.fontSize = 120
        Nlabel2.fontColor = SKColor.black
        Nlabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Nlabel2.position = CGPoint(x: card2.position.x, y: card2.position.y + card2.size.width / 4)
        Nlabel2.zPosition = 2
        self.addChild(Nlabel2)
        
        Llabel2.text = "\("A")"
        Llabel2.fontName = "American Typewriter Bold"
        Llabel2.fontSize = 120
        Llabel2.fontColor = SKColor.black
        Llabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Llabel2.position = CGPoint(x: card2.position.x, y: card2.position.y - card2.size.width / 2.2)
        Llabel2.zPosition = 2
        self.addChild(Llabel2)
        
        Nlabel3.text = "\(5)"
        Nlabel3.fontName = "American Typewriter Bold"
        Nlabel3.fontSize = 120
        Nlabel3.fontColor = SKColor.black
        Nlabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Nlabel3.position = CGPoint(x: card3.position.x, y: card3.position.y + card3.size.width / 4)
        Nlabel3.zPosition = 2
        self.addChild(Nlabel3)
        
        Llabel3.text = "\("A")"
        Llabel3.fontName = "American Typewriter Bold"
        Llabel3.fontSize = 120
        Llabel3.fontColor = SKColor.black
        Llabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        Llabel3.position = CGPoint(x: card3.position.x, y: card3.position.y - card3.size.width / 2.2)
        Llabel3.zPosition = 2
        self.addChild(Llabel3)
        
        //Duel Button
        
        
        var cgr = CGRect(x: card3.position.x, y: card3.position.y, width: card3.size.width, height: card3.size.width / 2)
        var duelbutton = SKSpriteNode(imageNamed: "duel")
        duelbutton.size = CGSize(width: card3.size.width, height: card3.size.width / 3)
//        duelbutton.setScale(0.53)
        duelbutton.position = CGPoint(x: card3.position.x, y: card3.position.y + card3.size.height / 2 + duelbutton.size.height)
        duelbutton.zPosition = 2
        self.addChild(duelbutton)
       
        
        
        
        
        
        
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
