//
//  UIView.swift
//  MacPaw
//
//  Created by Victor Pelivan on 19.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setShadowsAndCorners() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 0.5
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}
