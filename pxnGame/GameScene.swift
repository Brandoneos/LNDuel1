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
    
    let scoreLabel = SKLabelNode()
    
    var livesNumber = 3
    var livesLabel = SKLabelNode()
    
    var levelNumber = 0
    
    let player = SKSpriteNode(imageNamed: "rei3")
    
    let tapToStartLabel = SKLabelNode()
    
    var gameArea:CGRect
    
    enum gameState {
        //state machine
        case preGame //Game state is before the start of the game
        case inGame // Game state is during the game
        case afterGame // Game state is after the game
        
    }
    
    var currentGameState = gameState.preGame
    
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
        let playableWidth = size.height / maxAspectRatio
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
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(0.2)
        player.position = CGPoint(x: self.size.width / 2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        let mainframe = SKSpriteNode(imageNamed: "mainframe3")
        mainframe.setScale(1)
        mainframe.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0)
        mainframe.zPosition = 2
        mainframe.physicsBody = SKPhysicsBody(rectangleOf: mainframe.size)
        mainframe.physicsBody!.affectedByGravity = false
        mainframe.physicsBody!.categoryBitMask = PhysicsCategories.Mainframe
        mainframe.physicsBody!.collisionBitMask = PhysicsCategories.None
        mainframe.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(mainframe)
        
//        let bullet = SKSpriteNode(imageNamed: "ghost")
//        bullet.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
//        bullet.zPosition = 1
//        bullet.setScale(0.3)
//        self.addChild(bullet)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontName = "American Typewriter Bold"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.23, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontName = "American Typewriter Bold"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.77, y: self.size.height * 0.9)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        tapToStartLabel.text = "Tap To Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontName = "American Typewriter Bold"
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.zPosition = 1
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        
        startNewLevel()
        
    }
    
    func startGame() {
        
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction,startLevelAction])
        player.run(startGameSequence)
        
    
        
    }
    
    func loseLife() {
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
        
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50{
            startNewLevel()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            //the lower category number is body1
            //higher category number is body 2
            
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //if the player has hit the enemy
            
            
        
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            //loseLife function
            livesNumber = 0
            livesLabel.text = "Lives: 0"
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
            livesLabel.run(scaleSequence)
            //
            runGameOver()
        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            //if the bullet has hit the enemy
            
            addScore()
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            //question marks to avoid 2 enemies hitting bullet at once
            
            
        }
        if body1.categoryBitMask == PhysicsCategories.Enemy && body2.categoryBitMask == PhysicsCategories.Mainframe {
            
            //need to deduct a life
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            body1.node?.removeFromParent()
            loseLife()
        }
            
        
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        
        let explosion = SKSpriteNode(imageNamed: "cloud")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        
        self.addChild(explosion)
        //makes the explosion bigger, fades out, and deletes it.
        let scaleIn = SKAction.scale(to: 0.7, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn,fadeOut,delete])
        explosion.run(explosionSequence)
        
    }
    
    func startNewLevel() {
        
        levelNumber += 1
        
        if self.action(forKey: "spawnEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1.0
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
            
        default: levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnRat)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
        
        
    }
    
    
    func fireBullet() {
        let bullet  = SKSpriteNode(imageNamed: "ghost")
        bullet.name = "Bullet"
        bullet.setScale(0.3)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet,deleteBullet])
        bullet.run(bulletSequence)
        
        
    }
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet") {
            //makes a list of all the bullets(enumerate)
            bullet, stop in
            //calls all of the bullets on the list as "bullet"
            
            bullet.removeAllActions()
            
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
    
    
    func spawnRat() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "rat")
        enemy.name = "Enemy"
        enemy.setScale(0.4)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet | PhysicsCategories.Mainframe
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
//      let loseLifeAction = SKAction.run(loseLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy]) // could add loseLifeAction after deleteEnemy
        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }
        
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame {
            startGame()
        } else if currentGameState == gameState.inGame {
            fireBullet()
        }
            
        
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
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
