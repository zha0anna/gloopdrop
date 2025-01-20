//
//  SpriteKitHelper.swift
//  gloopdrop
//
//  Created by Anna Zhao on 3/11/24.
//

import Foundation
import SpriteKit

//physics bit masks
enum PhysicsCategory {
    static let none:        UInt32 = 0
    static let player:      UInt32 = 0b1
    static let collectible: UInt32 = 0b10
    static let foreground:  UInt32  = 0b100
}

enum Layer:CGFloat {
    case background
    case foreground
    case player
    case collectible
    case ui     //for the lavel nodes and other messages
}

extension SKSpriteNode {
    
    //Load texture arrays for animations
        func loadTextures(atlas: String, prefix: String,
                          startsAt: Int, stopsAt: Int) -> [SKTexture] {
            
            var textureArray = [SKTexture]()
            let textureAtlas = SKTextureAtlas(named: atlas)
            
            for i in startsAt...stopsAt {
                let textureName = "\(prefix)\(i)"
                let temp = textureAtlas.textureNamed(textureName)
                textureArray.append(temp)
            }
            
            return textureArray
        }
    
    
    //start the animation using a name and a count (0 = repeat forever)
        func startAnimation(textures: [SKTexture], speed: Double, name:String,
                            count: Int, resize: Bool, restore: Bool) {
            
            //run animation only if animation key does not already exist
            if(action(forKey: name) == nil) {
                let animation = SKAction.animate(with : textures, timePerFrame: speed,
                                                 resize: resize, restore: restore)
                
                if count == 0 {
                    //run animation until stopped
                    let repeatAction = SKAction.repeatForever(animation)
                    run(repeatAction, withKey: name)
                } else if count == 1 {
                    run(animation, withKey: name)
                } else {
                    let repeatAction = SKAction.repeat(animation, count: count)
                    run(repeatAction, withKey: name)
                }
            }
        }
}

extension SKScene {
    //these functions help us find the scene coordinates
    // where we want to place the labels
    
    //Top of view (physical screen
    func viewTop() -> CGFloat {
        return convertPoint(fromView: CGPoint(x: 0.0, y:0)).y
    }
    
    //Bottom of View (physical screen)
    func viewBottom() -> CGFloat {
        guard let view = view else {return 0.0}
        return convertPoint(fromView: CGPoint(x: 0.0, y: view.bounds.size.height)).y
}
}


