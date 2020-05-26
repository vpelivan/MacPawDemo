//
//  GallereyViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 23.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class GallereyViewController: UIViewController {

    var imageData = ImageData()
    var index: Int!
    var image: UIImage!
    var screenWidth: CGFloat!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = (view.frame.size.width - 6) / 3 // Setting the width of cell depending on different screens
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPicture" {
            guard let pvc = segue.destination as? ZoomImageViewController else { return }
            pvc.image = image
            pvc.imageData = imageData
            pvc.index = index
        }
    }
    
    @IBAction func unwindToGallery(_ unwindSegue: UIStoryboardSegue) {
    }
}

extension GallereyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gallereyCell", for: indexPath) as! GallereyCollectionViewCell
        cell.imageView.image = imageData.images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        index = indexPath.row
        image = imageData.images[indexPath.row]
        performSegue(withIdentifier: "goToPicture", sender: nil)
    }
}

extension GallereyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
