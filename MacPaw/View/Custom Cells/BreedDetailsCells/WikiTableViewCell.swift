//
//  WikiTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 24.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class WikiTableViewCell: UITableViewCell {

    @IBOutlet weak var wikiImageView: UIImageView!
    @IBOutlet weak var wikiContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wikiContainerView.setShadowsAndCorners()
        wikiImageView.setRadiusAndBounds()
    }
}
