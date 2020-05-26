//
//  ZoomImageViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 22.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

class ZoomImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var image = UIImage()
    var index: Int?
    var imageData = ImageData()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupScrollView()
        self.title = "Picture Detailed View"
        if index == nil {
            removeButton.isEnabled = false
        }
        
    }
    
    
    //MARK: - Removing Image from Gallerey
    @IBAction func removeImage(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Remove Picture?", message: "Are You sure You want to delete this image from gallery?", preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            guard let index = self.index else { return }
            self.imageData.images.remove(at: index)
            sender.isEnabled = false
            self.performSegue(withIdentifier: "unwindToGallery", sender: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    func setupScrollView() {
        imageView = UIImageView(image: image)
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        scrollView.maximumZoomScale = 3.0
    }
    
    func setZoomScale(for ScrollViewSize: CGSize) {
        let widthScale = ScrollViewSize.width / imageView.bounds.size.width
        let heightScale = ScrollViewSize.height / imageView.bounds.size.height
        let minimumScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minimumScale
        scrollView.zoomScale = minimumScale
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale(for: self.view.bounds.size)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
