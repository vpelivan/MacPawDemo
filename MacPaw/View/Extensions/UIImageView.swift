//
//  UIImageView.swift
//  MacPaw
//
//  Created by Victor Pelivan on 22.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRadiusAndBounds() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
