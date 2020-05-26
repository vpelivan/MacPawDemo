//
//  SettingsViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 22.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var buttons: [BlackButton]! // Collection of custom classes
    let animations = Animations() // My Animations
    var scoreData = ScoreData() // The Score Results Array
    var imageData = ImageData() // The Array of gallery images
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animations.appearButtonsFromRight(withDuration: 0.7, for: buttons)
    }
    
    //MARK: - Function shows alerts when user clears any data
    private func alert(title: String, message: String, completion: @escaping () -> ()) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Clear", style: .destructive) { (_) in
            completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(delete)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Next three actions Delete different kind of data
    
    @IBAction func tapClearCache(_ sender:
        UIButton) {
        alert(title: "Clear Cache", message: "Are you sure you want to delete all cache?") {
            NetworkService.shared.imageCache.removeAllObjects()
            self.performSegue(withIdentifier: "unwindToMainController", sender: nil)
        }
    }
    
    
    @IBAction func tapClearScoreResults(_ sender: UIButton) {
        
        alert(title: "Clear Score Table", message: "Are you sure you want to delete all score results?") {
            self.scoreData.scores.removeAll()
            self.performSegue(withIdentifier: "unwindToMainController", sender: nil)
        }
    }
    
    @IBAction func tapClearGallery(_ sender: UIButton) {

        alert(title: "Clear Images", message: "Are you sure you want to delete all images from gallerey?") {
            self.imageData.images.removeAll()
            self.performSegue(withIdentifier: "unwindToMainController", sender: nil)
        }
    }
}
