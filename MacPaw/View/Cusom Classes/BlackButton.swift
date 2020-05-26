//
//  ButtonSetup.swift
//  MacPaw
//
//  Created by Victor Pelivan on 18.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

    //MARK: - A custom UIButton class of black color buttons with rounded corners, white button label and white border, with grey shadows. This settings also perform preparations for animations

class BlackButton: UIButton {
    
    override func didMoveToWindow() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.layer.cornerRadius = 10
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 0.5
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        setForAnimations()
    }
    
    public func setForAnimations() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.transform = CGAffineTransform(translationX: 500, y: 0) // Setting button for animation
        self.alpha = 0 // Setting button for animation
    }
}
