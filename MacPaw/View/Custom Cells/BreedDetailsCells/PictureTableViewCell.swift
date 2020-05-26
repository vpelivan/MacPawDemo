//
//  PictureTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class PictureTableViewCell: UITableViewCell {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var customActivityIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainerView.setShadowsAndCorners()
        catImageView.setRadiusAndBounds()
    }

}
