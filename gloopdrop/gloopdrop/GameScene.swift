//
//  GameScene.swift
//  gloopdrop
//
//  Created by Anna Zhao on 3/7/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //GameScene Variables
    let player = Player()
    
    let playerSpeed : CGFloat = 1.5
    
    //player movement
    var movingPlayer = false    //initially blobenheimer is not
    var lastPosition: CGPoint?
    
    var level: Int = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var numberOfDrops: Int = 10     //drops for current level
    
    //used to determine if successfully completed a level
    var dropsExpected = 10   //first level
    var dropsCollected = 0
    
    var dropSpeed: CGFloat = 1.0
    var minDropSpeed: CGFloat = 0.12
    var maxDropSpeed: CGFloat = 1.0
    
    //labels
    var scoreLabel: SKLabelNode = SKLabelNode()
    var levelLabel: SKLabelNode = SKLabelNode()
    
    //Game states
    var gameInProgress = false
    
    //true if we are in the middle of a level
    //var playingLevel = false
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        //set up background
        let background = SKSpriteNode(imageNamed: "background_1")
        background.anchorPoint = CGPoint(x: 0, y: 0)    //image
        background.position = CGPoint(x:0, y:0)     //scene
        
        addChild(background)
        
        
        //set up foreground
        let foreground = SKSpriteNode(imageNamed: "foreground_1")
        foreground.anchorPoint = CGPoint(x: 0, y: 0)    //image
        foreground.position = CGPoint(x:0, y:0)     //scene
        
        foreground.physicsBody = SKPhysicsBody(edgeLoopFrom: foreground.frame)
        
        foreground.physicsBody?.affectedByGravity = false
        
        // Set up physics categories for contacts
        foreground.physicsBody?.categoryBitMask = PhysicsCategory.foreground
        foreground.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        foreground.physicsBody?.collisionBitMask = PhysicsCategory.none

        
        addChild(foreground)
        
        //set up labels
        setupLabels()
        
        //add player
        
        player.position = CGPoint(x: size.width/2, y: foreground.frame.maxY)
        
        player.setupConstraints(floor: foreground.frame.maxY)
        addChild(player)
        
        player.walk()
       
        //let touchDown call spawnMG
        //spawnMultipleGloops()
    }
    
  /*  //this function is called at the beginning of every pass thru the game loop
    //once per frame
    override func update(_ currentTime : TimeInterval) {
        checkForRemainingDrops()
    }
   */
    
    func setupLabels() {
            /* SCORE LABEL */
            scoreLabel.name = "score"
            //scoreLabel.fontName = "Nosifer"
            scoreLabel.fontColor = .yellow
            scoreLabel.fontSize = 35.0
            scoreLabel.horizontalAlignmentMode = .right
            scoreLabel.verticalAlignmentMode = .center
            scoreLabel.zPosition = Layer.ui.rawValue
            scoreLabel.position = CGPoint(x: frame.maxX - 50, y: viewTop() - 100)
         
            // Set the text and add the label node to scene
            scoreLabel.text = "Score: 0"
            addChild(scoreLabel)
            
            /* LEVEL LABEL */
            levelLabel.name = "level"
           // levelLabel.fontName = "Nosifer"
            levelLabel.fontColor = .yellow
            levelLabel.fontSize = 35.0
            levelLabel.horizontalAlignmentMode = .left
            levelLabel.verticalAlignmentMode = .center
            levelLabel.zPosition = Layer.ui.rawValue
            levelLabel.position = CGPoint(x: frame.minX + 50, y: viewTop() - 100)
         
            // Set the text and add the label node to scene
            levelLabel.text = "Level: \(level)"
            addChild(levelLabel)
          }

    
    // MARK: - TOUCH HANDLING
    
    /* ############################################################ */
    /*                 TOUCH HANDLERS STARTS HERE                   */
    /* ############################################################ */
    
    func touchDown(atPoint pos: CGPoint) {
        
        //calculate speed based on distance
  /*      let distance = hypot(pos.x - player.position.x, pos.y - player.position.y)
                  var drx:String = "R"

                  if pos.x < player.position.x {
                      drx = "L"
                  }
                  player.moveToPosition(pos: pos, direction: drx, speed: (distance/playerSpeed)/255)
   */
        
        //see if this is the first touch to start the game
        if gameInProgress == false {
            spawnMultipleGloops()
            return
        }
        
        let touchedNode = atPoint(pos)
        if touchedNode.name == "player" {
            movingPlayer = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func touchMoved(toPoint pos: CGPoint) {
            
            if movingPlayer == true {
                //Clamp position
                let newPos = CGPoint(x:pos.x, y: player.position.y)
                player.position = newPos
                
                //check last position; if empty set it
                let recordedPosition = lastPosition ?? player.position
                if recordedPosition.x > newPos.x {
                    player.xScale = -abs(xScale)
                }else {
                    player.xScale = abs(xScale)
                }
                
                //save last known position
                lastPosition = newPos
                
            }
            
          }
          
    func touchUp(atPoint pos: CGPoint) {
            movingPlayer = false
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    

    
    //MARK: GAME FUNCTIONS
    func spawnMultipleGloops() {
        
        player.walk()
        
        //reset level and score
        if gameInProgress == false {
            score = 0
            level = 1
        }
        
        // Set number of drops based on the level
                 switch level {
                  case 1, 2, 3, 4, 5:
                       numberOfDrops = level * 10
                  case 6:
                    numberOfDrops = 75
                  case 7:
                        numberOfDrops = 100
                  case 8:
                         numberOfDrops = 150
                  default:
                        numberOfDrops = 150
                  }

        //reset and update collected and expected counts
        dropsCollected = 0
        dropsExpected = numberOfDrops
        
        // set up drop speed based on the level (smaller number is faster)
        dropSpeed = 1/(CGFloat(level) + CGFloat(level) / CGFloat(numberOfDrops))
        
        if dropSpeed < minDropSpeed {
            dropSpeed = minDropSpeed
        } else if dropSpeed > maxDropSpeed {
            dropSpeed = maxDropSpeed
        }
        
        // Set up repeating action
                   let wait = SKAction.wait(forDuration: TimeInterval(dropSpeed))
                    let spawn = SKAction.run { [unowned self] in self.spawnGloop() }
                    let sequence = SKAction.sequence([wait, spawn])
                    let repeatAction = SKAction.repeat(sequence, count: numberOfDrops)
                // Run action
                  run(repeatAction, withKey: "gloop")
        
        //Update game state
        gameInProgress = true
       // playingLevel = true
        }

    
    func spawnGloop() {
        
        let collectible = Collectible(collectibleType: .gloop)
        
        //set random position
        
        //first make sure the drop is always completely visible and not cut off
        let margin = collectible.size.width * 2
        
        let dropRange = SKRange(lowerLimit: frame.minX + margin,
                                       upperLimit: frame.maxX - margin)
        
        let randomX = CGFloat.random(in: 
                            dropRange.lowerLimit...dropRange.upperLimit)
        
        collectible.position = (CGPoint(x: randomX, y:player.position.y * 2.5))
        
        addChild(collectible)
        
        collectible.drop(dropSpeed: TimeInterval(1.0), floorLevel: player.frame.minY)
        
    }
    
    func checkForRemainingDrops() {
      
            if dropsCollected == dropsExpected {
              //  playingLevel = false
                nextLevel()
            }
        }
    
         
    // Player PASSED level
    func nextLevel() {
            
     //       showMessage("Get Ready For The Next Level")
        let wait = SKAction.wait(forDuration: 2.25)
        run(wait, completion:{[unowned self] in self.level += 1
                                   self.spawnMultipleGloops()})
          }

    //PLAYER FAILED LEVEL
    func gameOver() {
        
        gameInProgress = false
        
        player.die()
        
        //remove repeatable action on main scene
        removeAction(forKey: "gloop")
        
        //loop thru child nodes and stop actions on collectibles
        enumerateChildNodes(withName: "//co_*") {
            (node, stop) in
            
            //stop and remove drops
            
            //remove action
            node.removeAction(forKey: "drop")
            
            //remove physics so no contacts occur
            node.physicsBody = nil
        }   //end loop
        
        resetPlayerPosition()
        popRemainingDrops()
    }
    
    func resetPlayerPosition() {
            let resetPoint = CGPoint(x: frame.midX, y: player.position.y)
            let distance = hypot(resetPoint.x-player.position.x, 0)
            let calculatedSpeed = TimeInterval(distance / (playerSpeed * 2)) / 255
         
            if player.position.x > frame.midX {
              player.moveToPosition(pos: resetPoint, direction: "L", speed: calculatedSpeed)
            } else {
              player.moveToPosition(pos: resetPoint, direction: "R", speed: calculatedSpeed)
            }
          }
          
          func popRemainingDrops() {
            var i = 0
            enumerateChildNodes(withName: "//co_*") {
              (node, stop) in
              
              // Pop remaining drops in sequence
              let initialWait = SKAction.wait(forDuration: 1.0)
              let wait = SKAction.wait(forDuration: TimeInterval(0.15 * CGFloat(i)))
              
              let removeFromParent = SKAction.removeFromParent()
              let actionSequence = SKAction.sequence([initialWait, wait, removeFromParent])
              
              node.run(actionSequence)
              
              i += 1
            }
          }
        
}

// MARK: - COLLISION DETECTION
 
/* ############################################################ */
/*         COLLISION DETECTION METHODS START HERE               */
/* ############################################################ */
 
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("called contact delegate")
        
        
        // Check collision bodies
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        
        // Did the [PLAYER] collide with the [COLLECTIBLE]?
        if collision == PhysicsCategory.player | PhysicsCategory.collectible {
            print("player hit collectible")
            
            //find out which body is the collectible
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node : contact.bodyB.node
            
            //verify the object is collectible
            if let sprite = body as? Collectible {
                sprite.collected()
                score += level
                dropsCollected += 1
                checkForRemainingDrops()
            }
        }
        
        // Or did the Collectible collide with the foreground?
        if collision == PhysicsCategory.foreground | PhysicsCategory.collectible {
            print("foreground hit collectible")
            
            //find out which body is the collectible
            let body = contact.bodyA.categoryBitMask == PhysicsCategory.collectible ?
            contact.bodyA.node : contact.bodyB.node
            
            //verify the object is collectible
            if let sprite = body as? Collectible {
                sprite.missed()
                gameOver()
            }
        }
        

    }
}
