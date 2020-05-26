//
//  Animations.swift
//  MacPaw
//
//  Created by Victor Pelivan on 5/17/20.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

class Animations {
    
    //MARK: - Simple UIImage rotation, kind of a custom activity indicator
    
    public func startRotateAnimation(imageView: UIImageView, circleTime: Double) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = Double.pi * 2 // Minus or plus is a direction of rotation
        rotation.duration = circleTime
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: nil)
    }
    
    
    //MARK: - Buttons unfade and appear from right side to left with spring effect one after another
    
    public func appearButtonsFromRight(withDuration duration: Double, for buttons: [UIButton]) {
        
        let averageDelay = duration / Double(buttons.count)
        var currentDelay = 0.0
        
        for button in buttons {
            UIView.animate(withDuration: duration, delay: currentDelay, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                button.transform = .identity
                button.alpha = 1
            })
            currentDelay += averageDelay
        }
    }
    
    //MARK: - Buttons fade and disappear
    
    public func dissappearButtonsWithFade(withDuration duration: Double, for buttons: [UIButton]) {
        
        let averageDelay = duration / Double(buttons.count)
        var currentDelay = 0.0
        
        for button in buttons {
            UIView.animate(withDuration: duration, delay: currentDelay, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                button.alpha = 0
//                button.transform = .identity
                button.isEnabled = false
    })
            currentDelay += averageDelay
        }
    }
}
