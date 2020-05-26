//
//  VcaTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class VcaTableViewCell: UITableViewCell {

    @IBOutlet weak var vcaImageView: UIImageView!
    @IBOutlet weak var vcaContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vcaContainerView.setShadowsAndCorners()
        vcaImageView.setShadowsAndCorners()
    }
}
