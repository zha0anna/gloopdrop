//
//  GameViewController.swift
//  gloopdrop
//
//  Created by Anna Zhao on 3/7/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create view
        if let view = self.view as! SKView? {
            
            //create the scene
           // let scene = GameScene(size: view.bounds.size)
            let scene = GameScene(size: CGSize(width: 1336, height: 1024))
            
            //set the scale mode to fill view window
            scene.scaleMode = .aspectFill
            
            //set background color
            scene.backgroundColor = UIColor(red : 105/255, green : 157/255, blue : 181/255, alpha: 1.0)
            
            //present the scene
            view.presentScene(scene)
            
            //set options for the view
            view.ignoresSiblingOrder = false
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
