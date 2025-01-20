//
//  Player.swift
//  gloopdrop
//
//  Created by Anna Zhao on 3/11/24.
//

import Foundation
import SpriteKit

//This enum lets you switch between animations
enum PlayerAnimationType: String {
    case walk
    case die
}

class Player : SKSpriteNode {
    
    // MARK: - PROPERTIES
    private var walkTextures: [SKTexture]?
    private var dieTextures: [SKTexture]?
    
    // MARK: - INIT
    init() {
        
        //set default starting texture
        let texture = SKTexture(imageNamed: "blob-walk_0")
        
        super.init(texture: texture, color: .clear,
                   size:texture.size())
        
        self.walkTextures = self.loadTextures(atlas: "Blob",
                                              prefix: "blob-walk_",
                                              startsAt: 0, stopsAt: 2)
        
        self.dieTextures = self.loadTextures(atlas: "Blob",
                                              prefix: "blob-die_",
                                              startsAt: 0, stopsAt: 0)
        
        //set up other properties
        self.name = "player"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        //anchor is center bottom
        
        //add physics body
        self.physicsBody = SKPhysicsBody(rectangleOf:self.size,
                            center: CGPoint(x: 0.0, y:self.size.height/2))
        self.physicsBody?.affectedByGravity = false
        
        // Set up physics categories for contacts
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.collectible
        self.physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        fatalError("init(coder): has not been inplemented")
    }
    
    // MARK: - METHODS
    
    func walk() {
        //check for textures
        guard let walkTextures = walkTextures else {
            preconditionFailure("Could not find textures")
        }
        
        //remove the die animation
        removeAction(forKey: PlayerAnimationType.die.rawValue)
        
        //run the animation forever
        startAnimation(textures: walkTextures, speed: 0.25,
                       name: PlayerAnimationType.walk.rawValue,
                       count: 0, resize: true, restore: true)
    }
    
    func die() {
        //check for textures
        guard let dieTextures = dieTextures else {
            preconditionFailure("Could not find textures")
        }
        
        //remove the walk animation
        removeAction(forKey: PlayerAnimationType.walk.rawValue)
        
        //run the animation forever
        startAnimation(textures: dieTextures, speed: 0.25,
                       name: PlayerAnimationType.die.rawValue,
                       count: 0, resize: true, restore: true)
    }
    
    func setupConstraints(floor: CGFloat) {
        let range = SKRange(lowerLimit: floor, upperLimit: floor)
        
        let lockToPlatform = SKConstraint.positionY(range)
        
        constraints = [lockToPlatform]
    }
    
    func moveToPosition(pos: CGPoint, direction: String, speed: TimeInterval) {
        
        switch direction {
        case "L":
            xScale = -abs(xScale)
        default:
            xScale = abs(xScale)
        }   //end switch
        
        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
    }
    
    
}
