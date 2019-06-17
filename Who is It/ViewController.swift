//
//  ViewController.swift
//  Who is It
//
//  Created by Paula Leite on 17/06/19.
//  Copyright © 2019 Paula Leite. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var labelPoints: UILabel!
    
    var referenceAttitude: CMAttitude?
    
    let motion = CMMotionManager()
    
    var lastXUpdate = 0
    var lastYUpdate = 0
    var lastZUpdate = 0
    
    var nameText: [String] = ["Harry Potter", "Snow White", "John Wayne", "Anne Hathaway", "Madonna", "Superman", "Dilma", "Brittany Spears", "Cinderella", "Helen of Troy", "Cleopetra", "Queen Elizabeth", "Angelina Jolie", "Bill Clinton", "Ellen DeGeneres"]
    
    var canChange = false
    
    var counter = 0
    var points = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detectMotion()
        self.nameText.shuffle()
        self.name.text = self.nameText[0]
    }
    
    func detectMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true, block: {(timer) in
                if let data = self.motion.deviceMotion {
                    
                    self.counter += 1
                    
                    var relativeAttitude = data.attitude
                    if let ref = self.referenceAttitude {
                        relativeAttitude.multiply(byInverseOf: ref)
                    }
                    
                    let x = relativeAttitude.pitch
                    let y = relativeAttitude.roll
                    let z = relativeAttitude.yaw
                    
//                    let gravity = data.gravity
//
//                    let rotation = atan2(gravity.x, gravity.y) - .pi
//
//                    if (rotation ) && self.canChange
//
                    if (y > 1.6 || y < -1.6) && self.canChange {

                        if self.nameText.count > 1 {
                            self.nameText.removeFirst()
                            self.name.text = self.nameText[0]
                            self.canChange = false
                            self.points += 1
                            self.labelPoints.text = String(self.points)
                        }
                        
                        
                        
                        
                    } else {
                        self.view.backgroundColor = UIColor.white
                        
                    }
                    
                    if self.counter >= 60 {
                        if (y > 0 && y < 3) || (y < -0 && y > -3) {
                            self.canChange = true
                            self.counter = 0
                            //self.view.backgroundColor = UIColor.green
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
            
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let att = motion.deviceMotion?.attitude {
            referenceAttitude = att
            self.canChange = true
        }
    }
    
    
}

