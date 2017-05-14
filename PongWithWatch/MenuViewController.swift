//
//  MenuViewController.swift
//  PongWithWatch
//
//  Created by Michael Castillo on 5/8/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import CoreMotion
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var spaceshipButton: UIButton!

    fileprivate var motionController = MotionController()
    fileprivate var index = 0
    
    
    // Life - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionController.accelDataUpdated = updateUI(with:)
        motionController.startAccelorometerUpdates()
        applyMotionEffects(toView: backgroundImage, magnitude: 50)
        applyMotionEffects(toView: spaceshipButton, magnitude: -100)
    }
    
    @IBAction func spaceshipButtonTapped(_ sender: Any) {
        // Segue
    }
    
    func updateUI(with accelData: AxisData) {
        let xIsPositive = accelData.x > 0
        if xIsPositive {
            index = index == 106 ? 0 : index + 1
        } else {
            index = index == 0 ? 106 : index - 1
        }
        backgroundImage.image = motionController.images[index]
    }
    
}

extension MenuViewController {
    
    // Parallax effects
    func applyMotionEffects(toView view: UIView, magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        spaceshipButton.addMotionEffect(group)
    }
    
}
