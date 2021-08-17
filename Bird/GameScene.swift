//
//  GameScene.swift
//  Bird
//
//  Created by Min on 7/6/16.
//  Copyright (c) 2016 mihinduDeSilva. All rights reserved.
//

import SpriteKit

struct PhysicsBodies {
    static let Player : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Walls : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = Int()
    
    var ground = SKSpriteNode()
    var player = SKSpriteNode()
    var wallPair = SKNode()
    var gameStarted = Bool()
    var moveAndRemove = SKAction()
    
    var playerIsDead = Bool()
    var background = SKSpriteNode()
    var btnRestart = SKSpriteNode()
    
    var lblScore = SKLabelNode(fontNamed:"Chalkduster")
    
    var highScore = 0
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        gameStarted = false
        playerIsDead = false
        score = 0
        createScene()
    }
    
    func createScene() {
        
        
        
        self.physicsWorld.contactDelegate = self
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPointMake(self.frame.width/2, self.frame.height/1.9)
        self.addChild(background)
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.position = CGPointMake((self.frame.width/2), self.ground.frame.height/2 )
        ground.zPosition = 3
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsBodies.Ground
        ground.physicsBody?.collisionBitMask = PhysicsBodies.Player
        ground.physicsBody?.contactTestBitMask = PhysicsBodies.Player
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.dynamic = false
        
        
        lblScore.text = "Tap to Start"
        lblScore.fontSize = 60
        lblScore.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height - 100)
        lblScore.zPosition = 4
        
        player = SKSpriteNode(imageNamed: "playerIcon")
        player.position = CGPointMake(self.frame.width/2.5, self.frame.height/2)
        player.setScale(0.08)
        player.zPosition = 2
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.height/2)
        player.physicsBody?.categoryBitMask = PhysicsBodies.Player
        player.physicsBody?.collisionBitMask = PhysicsBodies.Ground | PhysicsBodies.Walls
        player.physicsBody?.contactTestBitMask = PhysicsBodies.Ground | PhysicsBodies.Walls | PhysicsBodies.Score
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        
        self.addChild(player)
        self.addChild(lblScore)
        self.addChild(ground)
        
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let highScoreDefault = NSUserDefaults.standardUserDefaults()
        
        if (highScoreDefault.valueForKey("highScore") != nil) {
            highScore = highScoreDefault.valueForKey("highScore") as! NSInteger

        }
        createScene()
        
    }
    
    func CreateWalls() {
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        wallPair.name = "wallPair"
        let scoreArea = SKSpriteNode()
        
        scoreArea.size = CGSize(width: 1, height: 160)
        scoreArea.position = CGPoint(x:self.frame.width, y:self.frame.height/2)
        scoreArea.physicsBody = SKPhysicsBody(rectangleOfSize: (scoreArea.size))
        
        scoreArea.physicsBody?.affectedByGravity = false
        scoreArea.physicsBody?.dynamic = false
        scoreArea.physicsBody?.categoryBitMask = PhysicsBodies.Score
        scoreArea.physicsBody?.collisionBitMask = 0
        scoreArea.physicsBody?.contactTestBitMask = PhysicsBodies.Player
        
        
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2+350)
        btmWall.position = CGPoint(x: self.frame.width, y: self.frame.height/2-350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsBodies.Walls
        topWall.physicsBody?.collisionBitMask = PhysicsBodies.Player
        topWall.physicsBody?.contactTestBitMask = PhysicsBodies.Player
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.dynamic = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsBodies.Walls
        btmWall.physicsBody?.collisionBitMask = PhysicsBodies.Player
        btmWall.physicsBody?.contactTestBitMask = PhysicsBodies.Player
        btmWall.physicsBody?.affectedByGravity = false
        btmWall.physicsBody?.dynamic = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        // scoreArea.color = SKColor.blueColor()
        wallPair.addChild(scoreArea)
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1 //Setting the order of the wall pair to be at the back
        
        
        //Make walls random
        let randomPosition = CGFloat(arc4random_uniform(UInt32(400)))-200
        wallPair.position.y = randomPosition
        wallPair.runAction(moveAndRemove)
        self.addChild(wallPair)
        
    }
    
    func createBTN(){
        
        if playerIsDead == false {
            
            lblScore.setScale(0)
            lblScore.text = "Game Over! You got \(score)!"
            
            let lblHighScore = SKLabelNode(fontNamed: "Chalkduster")
            btnRestart = SKSpriteNode(imageNamed: "restartBtn")
            let btnHeight = btnRestart.size.height*0.5
            
            //print(btnHeight)
            btnRestart.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
            btnRestart.zPosition = 22
            btnRestart.zRotation = CGFloat(M_PI/50)
            btnRestart.setScale(0)
            
            self.addChild(btnRestart)
            
            btnRestart.runAction(SKAction.scaleTo(0.5, duration: 0.2))
            
            let blurred = SKSpriteNode(color: UIColor.blackColor().colorWithAlphaComponent(0.7), size: CGSize(width: self.frame.width, height: self.frame.height/1.5))
            
            blurred.position = CGPoint(x: self.frame.width/2, y: btnRestart.position.y + blurred.size.height/3) // btnHeight/2)
            blurred.zPosition = 21
            blurred.zRotation = CGFloat(M_PI/50)
            
            blurred.setScale(0)
            self.addChild(blurred)
            blurred.runAction(SKAction.scaleTo(1, duration: 0.2))
            
            //move label
            
            lblScore.position.x = blurred.position.x
            lblScore.position.y = blurred.position.y + btnHeight
            lblScore.zPosition = 30
            lblScore.fontSize = 30
            lblScore.runAction(SKAction.scaleTo(1, duration: 0.2))
            
            //present highscore value
            
            lblHighScore.fontSize = 30
            lblHighScore.position = blurred.position
            lblHighScore.zPosition = 40
            lblHighScore.text = "Your highscore is: \(highScore)"
            
            self.addChild(lblHighScore)
        }
        
        playerIsDead = true
    }
    
    
    func deathSequence(){
        
        
        createBTN()
        enumerateChildNodesWithName("wallPair", usingBlock: ({
            (node, error) in
            
            node.speed = 0
            self.removeAllActions()
            
            
        }))
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let objectA = contact.bodyA
        let objectB = contact.bodyB
        
        if objectA.categoryBitMask == PhysicsBodies.Score && objectB.categoryBitMask == PhysicsBodies.Player || objectA.categoryBitMask == PhysicsBodies.Player && objectB.categoryBitMask == PhysicsBodies.Score {
            
            score += 1
            lblScore.text = "\(score)"
        }
        
        if objectA.categoryBitMask == PhysicsBodies.Player && objectB.categoryBitMask == PhysicsBodies.Walls || objectA.categoryBitMask == PhysicsBodies.Walls && objectB.categoryBitMask == PhysicsBodies.Player || objectA.categoryBitMask == PhysicsBodies.Player && objectB.categoryBitMask == PhysicsBodies.Ground || objectA.categoryBitMask == PhysicsBodies.Ground && objectB.categoryBitMask == PhysicsBodies.Player   {
            
            if score > highScore {
                highScore = score
                
                let highScoreDefault = NSUserDefaults.standardUserDefaults()
                highScoreDefault.setValue(highScore, forKey: "highScore")
                highScoreDefault.synchronize()
                
            }
            deathSequence()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if playerIsDead{
            
            for touch in touches {
                let location = touch.locationInNode(self)
               // print("X: \(location.x) Y: \(location.y)")
                
                if btnRestart.containsPoint(location){
                 restartScene()
                 }
            }
            
        }else {
            if gameStarted {
                
                player.physicsBody?.velocity = CGVectorMake(0, 0)
                player.physicsBody?.applyImpulse(CGVectorMake(0,40))
                
            }else{
                
                lblScore.text = "\(score)"
                player.physicsBody?.affectedByGravity = true
                
                playerIsDead = false
                
                //Creating multiple walls
                let spawnWalls = SKAction.runBlock({ () in
                    self.CreateWalls()
                })
                
                gameStarted = true
                let delay = SKAction.waitForDuration(2.0)
                let spawnDelay = SKAction.sequence([spawnWalls,delay])
                let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
                self.runAction(spawnDelayForever)
                
                //moving Walls
                //if playerIsDead == false{
                let distance = CGFloat(self.frame.width + wallPair.frame.width)
                let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.009 * distance))
                let removePipes = SKAction.removeFromParent()
                
                moveAndRemove = SKAction.sequence([movePipes,removePipes])
                //}
                player.physicsBody?.velocity = CGVectorMake(0, 0)
                player.physicsBody?.applyImpulse(CGVectorMake(0,40))
                
                
            }
        }
        
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
