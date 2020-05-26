//
//  ListOfBreedsViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 20.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class ListOfBreedsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var allBreeds: [Breed] = []
    let animations = Animations()
    var imageData = ImageData()
    let request = NetworkService.shared
    var catImage: UIImage!
    var singleBreed: Breed!
    var imageURL: URL!
    var searchController: UISearchController!
    var filteredResultsArray: [Breed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationBar()
    }
    
    
    //MARK: - Next function integrates and sets the SearchBar into a NavigationBar
    private func setupNavigationBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search for Cat Breed"
    }
    
    //MARK: - The next function adds found results during search in filteredResultsArray
    private func filterContentFor(searchText text: String) {
        filteredResultsArray = allBreeds.filter{ (breed) -> Bool in
            return (breed.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    //MARK: - The method dismisses keyboard when user touches controller during search
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func breedTodisplayAt(indexPath: IndexPath) -> Breed {
        let breed: Breed
        
        if searchController.isActive && searchController.searchBar.text != "" {
            breed = filteredResultsArray[indexPath.row]
        } else {
            breed = allBreeds[indexPath.row]
        }
        return breed
    }
    
    //MARK: - setting all the cell data
    private func setData(for indexPath: IndexPath) -> BreedTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath) as! BreedTableViewCell
        let breed = breedTodisplayAt(indexPath: indexPath)
        guard let id = breed.id else { return BreedTableViewCell() }
        let catURL = "https://api.thecatapi.com/v1/images/search?breed_id=\(id)"
        cell.tag = indexPath.row
        cell.catImageView.image = nil
        cell.customActivityIdicator.isHidden = false
        animations.startRotateAnimation(imageView: cell.customActivityIdicator, circleTime: 0.8)
        let task = request.downloadCellImage(url: catURL, id: id) { (image, url) in
            DispatchQueue.main.async {
                if cell.tag == indexPath.row {
                    cell.imageURL = url
                    cell.catImageView.image = image
                    cell.customActivityIdicator.stopAnimating()
                    cell.customActivityIdicator.isHidden = true
                }
            }
        }
        cell.nameLabel.text = breed.name
        cell.countryLabel.text = breed.origin
        cell.descriptionLabel.text = breed.breedDescription
        cell.task = task
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? DetailsTableViewController else { return }
        dvc.catImage = catImage
        catImage = nil
        dvc.breed = singleBreed
        dvc.imageURL = imageURL
        dvc.imageData = imageData
    }
}

extension ListOfBreedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultsArray.count
        }
        return allBreeds.count
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = setData(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? BreedTableViewCell else { return }
        self.catImage = cell.catImageView.image
        self.imageURL = cell.imageURL
        let breed = breedTodisplayAt(indexPath: indexPath)
        self.singleBreed = breed
        performSegue(withIdentifier: "goToDetails", sender: nil)
    }
}

extension ListOfBreedsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
