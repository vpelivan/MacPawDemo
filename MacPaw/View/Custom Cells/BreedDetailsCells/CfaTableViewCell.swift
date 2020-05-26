//
//  cfaTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class CfaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cfaImageView: UIImageView!
    @IBOutlet weak var cfaContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cfaContainerView.setShadowsAndCorners()
        cfaImageView.setShadowsAndCorners()
    }
}
