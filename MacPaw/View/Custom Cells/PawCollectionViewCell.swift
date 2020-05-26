//
//  PawCollectionViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 23.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class PawCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if traitCollection.userInterfaceStyle == .light {
            imageView.image = UIImage(named: "cat-paw-empty")
        } else {
            imageView.image = UIImage(named: "cat-paw-empty-white")
        }
    }

}
