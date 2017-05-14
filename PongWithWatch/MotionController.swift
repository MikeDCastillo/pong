//
//  GestureController.swift
//  PongWithWatch
//
//  Created by Michael Castillo on 4/21/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import CoreMotion
import UIKit

struct AxisData {
    
    var x: Double
    var y: Double
    var z: Double
    
    init(_ accel: CMAccelerometerData) {
        self.x = accel.acceleration.x
        self.y = accel.acceleration.y
        self.z = accel.acceleration.z
    }

}
    
struct MotionController {
    
    // MARK: - Static
    
    static let shared = MotionController()
    
    
    // MARK: - Public
    
    var accelDataUpdated: ((AxisData) -> Void)?

    fileprivate var motionManager = CMMotionManager()
    fileprivate let currentOpQueue = OperationQueue.current
    
    lazy var images: [UIImage] = {
        var images: [UIImage] = []
        
        for i in 1...107 {
            let imageName = "gridStarSystem-\(i) (dragged)"
            guard let image = UIImage(named: imageName) else { break }
            images.append(image)
        }
        
        return images
    }()
    
    
    // MARK: - Functions
    
    func startAccelorometerUpdates() {
        guard let currentOpQueue = currentOpQueue else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: currentOpQueue) { (data, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let axisData = AxisData(data)
                    self.accelDataUpdated?(axisData)
                    self.updateFrameRate(with: axisData)
                }
            }
        }
    }
    
    fileprivate func updateFrameRate(with data: AxisData) {
        let x = data.x
        let newFrameRate = abs(x) * -0.16 + 0.1
        motionManager.accelerometerUpdateInterval = newFrameRate
    }
    
}
