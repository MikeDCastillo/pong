//
//  InterfaceController.swift
//  WatchPong Extension
//
//  Created by Michael Castillo on 4/29/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        let width2 =  pongBall.size.width/2
//        let height2 =  sub.size.height/2
//        let xRange = SKRange(lowerLimit:0+width2,upperLimit:size.width-width2)
//        let yRange = SKRange(lowerLimit:0+height2,upperLimit:size.height-height2)
//        sub.constraints = [SKConstraint.positionX(xRange,Y:yRange)]
        
        // Configure interface objects here.
        crownSequencer.focus()
        crownSequencer.delegate = self
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = GameScene(fileNamed: "GameScene") {
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

    // MARK: - Crown Delegates

extension InterfaceController: WKCrownDelegate {

    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
    
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        
    }
}
