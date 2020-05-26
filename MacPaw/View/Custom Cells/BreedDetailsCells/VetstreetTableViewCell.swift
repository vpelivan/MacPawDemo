//
//  VetstreetTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class VetstreetTableViewCell: UITableViewCell {

    @IBOutlet weak var vetstreetImageView: UIImageView!
    @IBOutlet weak var vetstreetContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vetstreetContainerView.setShadowsAndCorners()
        vetstreetImageView.setShadowsAndCorners()
    }
}
