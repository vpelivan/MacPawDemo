//
//  BreedTableViewCell.swift
//  MacPaw
//
//  Created by Victor Pelivan on 21.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureContainerView: UIView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var customActivityIdicator: UIImageView!
    
    var task: URLSessionDataTask?
    var imageURL: URL?
    let animations = Animations()
    let request = NetworkService.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        catImageView.image = nil
        customActivityIdicator.isHidden = false
        animations.startRotateAnimation(imageView: customActivityIdicator, circleTime: 0.8)
    }
    
    private func setCellView() {
        customActivityIdicator.isHidden = true
        customActivityIdicator.stopAnimating()
        pictureContainerView.setShadowsAndCorners()
        containerView.setShadowsAndCorners()
        catImageView.setRadiusAndBounds()
    }
}
