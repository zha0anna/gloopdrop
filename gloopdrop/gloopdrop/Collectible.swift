//
//  Collectible.swift
//  gloopdrop
//
//  Created by Anna Zhao on 3/19/24.
//

import Foundation

import SpriteKit

// This enum lets you add different types of collectibles

enum CollectibleType: String {
  case none
  case gloop
}

class Collectible: SKSpriteNode {

  // MARK: - PROPERTIES

  private var collectibleType: CollectibleType = .none

  /*private let playCollectSound = SKAction.playSoundFileNamed("collect.wav",
                                                    waitForCompletion: false)
  private let playMissSound = SKAction.playSoundFileNamed("miss.wav",
                                                    waitForCompletion: false)*/

  // MARK: - INIT

  init(collectibleType: CollectibleType) {

    var texture: SKTexture!
    self.collectibleType = collectibleType

    // Set the texture based on the type
    switch self.collectibleType {
        case .gloop:
      texture = SKTexture(imageNamed: "gloop")

        case .none:
      break

    }

    // Call to super.init
    super.init(texture: texture, color: SKColor.clear, size: texture.size())

    // Set up collectible
    self.name = "co_\(collectibleType)"
    self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    self.zPosition = Layer.collectible.rawValue

      //add physics body
      self.physicsBody = SKPhysicsBody(rectangleOf:self.size,
                          center: CGPoint(x: 0.0, y:-self.size.height/2))
      self.physicsBody?.affectedByGravity = false
      
      //set up physics categories for contacts
      self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
      self.physicsBody?.contactTestBitMask = PhysicsCategory.player | PhysicsCategory.foreground
      self.physicsBody?.collisionBitMask = PhysicsCategory.none
  }

  // Required init

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    // MARK: - FUNCTIONS

    func drop(dropSpeed: TimeInterval, floorLevel : CGFloat)  {//floor is where to stop
        
        //create the stopping position CGPoint
        let pos = CGPoint(x: position.x, y: floorLevel)
            
        //create the action to stretch the gloop
            let scaleX = SKAction.scaleX(to: 1.0, duration: 1.0)
            let scaleY = SKAction.scaleY(to: 1.3, duration: 1.0)
            let scale = SKAction.group( [scaleX, scaleY])
            
            //action to make the gloop drop
            let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
            let moveAction = SKAction.move(to: pos, duration: dropSpeed)
            
            //chain the 3 actions in a sequence
            let actionSequence = SKAction.sequence([appear, scale, moveAction])
            
            //shrink the droplet initially, then drop it
            self.scale(to: CGSize(width: 0.25, height: 1.0))
            self.run(actionSequence, withKey: "drop")
        }
    
    //Handle Contacts
    func collected() {
        //blobenheimer touched the drop
        let removeFromParent = SKAction.removeFromParent()
        
        self.run(removeFromParent)
    }
    
    func missed() {
        //blobenheimer missed the drop, drop touched the foreground
        let removeFromParent = SKAction.removeFromParent()
        
        self.run(removeFromParent)
    }
  }


