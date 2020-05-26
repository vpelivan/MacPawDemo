//
//  DetailsTableViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 21.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class DetailsTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageButton: UIBarButtonItem!
    
    let request = NetworkService.shared
    let animations = Animations()
    var imageData = ImageData()
    var catImage: UIImage?
    var breed: Breed?
    var imageURL: URL?
    var index = 44 // This index is a counter of collection views cells, when cellForItem at indexPath delegate method executes, it decrements it so depending on range of it, collection views use their unique API data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = breed?.name ?? "-"
        if catImage == nil {
            addImageButton.isEnabled = false
        }
    }
    
    @IBAction func tapAddImageToGallerey(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        guard let image = catImage else { return }
        imageData.images.append(image)

    }
    
    private func fetchImage(for indexPath: IndexPath) -> PictureTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureTableViewCell", for: indexPath) as! PictureTableViewCell
        
        cell.customActivityIndicator.isHidden = true
        if catImage != nil {
            cell.catImageView.image = catImage
            addImageButton.isEnabled = true
        } else {
            guard let id = breed?.id else { return PictureTableViewCell()}
            let catURL = "https://api.thecatapi.com/v1/images/search?breed_id=\(id)"
            cell.customActivityIndicator.isHidden = false
            animations.startRotateAnimation(imageView: cell.customActivityIndicator, circleTime: 0.8)
            _ = request.downloadCellImage(url: catURL, id: id) { (image, _) in
                DispatchQueue.main.async {
                    cell.catImageView.image = image
                    self.catImage = image
                    self.addImageButton.isEnabled = true
                    cell.customActivityIndicator.stopAnimating()
                    cell.customActivityIndicator.isHidden = true
                }
            }
        }
        return cell
    }
    
    private func fetchDescription(for indexPath: IndexPath) -> DescriptionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
        
        cell.descriptionLabel.text = breed?.breedDescription ?? "No Description"
        
        return cell
    }
    
    //MARK: - We need to proceed in case if any value is nil, that's why we use Default values instead of optional binding
    private func fetchParams(for indexPath: IndexPath) -> ParamTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParamTableViewCell", for: indexPath) as! ParamTableViewCell
        
        cell.counrtyLabel.text = "\(breed?.origin ?? "-") (\(breed?.countryCodes ?? "-"))"
        cell.temperamentLabel.text = "\(breed?.temperament ?? "-")"
        if breed?.altNames?.isEmpty == true {
            cell.altNamesLabel.text = "-"
        } else {
            cell.altNamesLabel.text = "\(breed?.altNames ?? "-")"
        }
        cell.lifeSpanLabel.text = "\(breed?.lifeSpan ?? "-") years"
        cell.weightLabel.text = "\(breed?.weight?.metric ?? "-") kg"
        return cell
    }
    
    private func fetchLevels(for indexPath: IndexPath) -> LevelTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelTableViewCell", for: indexPath) as! LevelTableViewCell
        let nibCell = UINib(nibName: "PawCollectionViewCell", bundle: nil)
        for collectionView in cell.collectionViews {
            collectionView.register(nibCell, forCellWithReuseIdentifier: "pawCell")
        }
        return cell
    }
    
    private func fetchWikiLink(for indexPath: IndexPath) -> WikiTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiTableViewCell", for: indexPath) as! WikiTableViewCell
        return cell
    }
    
    private func fetchCfaLink(for indexPath: IndexPath) -> CfaTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CfaTableViewCell", for: indexPath) as! CfaTableViewCell
        return cell
    }
    private func fetchVetsteetLink(for indexPath: IndexPath) -> VetstreetTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VetstreetTableViewCell", for: indexPath) as! VetstreetTableViewCell
        return cell
    }
    
    private func fetchVcaLink(for indexPath: IndexPath) -> VcaTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VcaTableViewCell", for: indexPath) as! VcaTableViewCell
        return cell
    }

    private func goToSafariVC(for urlString: String?) {
        print(urlString ?? "nil")
        guard let urlString = urlString, let url = URL(string: urlString) else {
            let ac = UIAlertController(title: "Could not open link", message: "For some reasons the browser could not open this link", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ac.addAction(ok)
            present(ac, animated: true)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let zvc = segue.destination as? ZoomImageViewController else { return }
        guard let image = catImage else { return }
        zvc.image = image
    }
    
    private func getCollectionViewData() -> Int {
        var data: Int!

        switch index {
        case 0..<5: data = breed?.adaptability
        case 5..<10: data = breed?.affectionLevel
        case 10..<15: data = breed?.childFriendly
        case 15..<20: data = breed?.dogFriendly
        case 20..<25: data = breed?.energyLevel
        case 25..<30: data = breed?.healthIssues
        case 30..<35: data = breed?.intelligence
        case 35..<40: data = breed?.socialNeeds
        case 40..<45: data = breed?.strangerFriendly
        default: break
        }
        index -= 1
        return data
    }
}

extension DetailsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return fetchImage(for: indexPath)
        case 1: return fetchDescription(for: indexPath)
        case 2: return fetchParams(for: indexPath)
        case 3: return fetchLevels(for: indexPath)
        case 4: return fetchWikiLink(for: indexPath)
        case 5: return fetchCfaLink(for: indexPath)
        case 6: return fetchVetsteetLink(for: indexPath)
        case 7: return fetchVcaLink(for: indexPath)
        default: break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 && catImage != nil {
            performSegue(withIdentifier: "goToFullSize", sender: nil)
        }
        if indexPath.row == 4 {
            goToSafariVC(for: breed?.wikipediaURL)
        }
        if indexPath.row == 5 {
            goToSafariVC(for: breed?.cfaURL)
        }
        if indexPath.row == 6 {
            goToSafariVC(for: breed?.vetstreetURL)
        }
        if indexPath.row == 7 {
            goToSafariVC(for: breed?.vcahospitalsURL)
        }
    }
}

extension DetailsTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pawCell", for: indexPath) as! PawCollectionViewCell

        let data = getCollectionViewData()
        if indexPath.row < data {
            if traitCollection.userInterfaceStyle == .light {
                cell.imageView.image = UIImage(named: "cat-paw-filled")
            } else {
                cell.imageView.image = UIImage(named: "cat-paw-filled-white")
            }
        }
        return cell
    }
    
    
}
