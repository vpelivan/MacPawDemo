//
//  GallereyCollectionViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 23.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class GallereyCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        containerView.layer.borderWidth = 0.5
        imageView.setRadiusAndBounds()
    }
}
