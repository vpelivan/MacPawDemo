//
//  ViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 5/12/20.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit
import CoreData

/* For My Biggest Regrets, I've only got time to manage saving the score results in CoreData(((
I did't manage to save/load images to Gallerey((( and delete data from coreData((( and I'm writing this comment at 23:11 24.05.2020((( that's all I got time for, SO PLEASE DO NOT JUDJE TO TO STRICTLY(
 */

class MainViewController: UIViewController {
    
    @IBOutlet weak var customActivityIndicator: UIImageView!
    @IBOutlet weak var statusString: UILabel!
    @IBOutlet var buttons: [BlackButton]! //Custom Class
    
    var allBreeds: [Breed] = [] //The data of all breeds
    var scoreData = ScoreData() //Score Results table data
    var imageData = ImageData() // Image Array
    let animations = Animations() // My animations Class
    let request = NetworkService.shared // API Manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        customActivityIndicator.isHidden = true
        statusString.isHidden = true
        if traitCollection.userInterfaceStyle == .light {
            customActivityIndicator.image = UIImage(named: "MacPawLogo")
        } else {
            customActivityIndicator.image = UIImage(named: "MacPawLogoWhite")
        }
        makeCoreDataFetchRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if allBreeds.isEmpty == true {
            getAllBreeds()
        } else {
            animations.appearButtonsFromRight(withDuration: 0.7, for: buttons)
        }
    }
    
    //MARK: - The function Loads Data (Score Results) from Core Data
    private func makeCoreDataFetchRequest() {
        let scoresFetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        do {
            let scores = try PersistenceSerive.context.fetch(scoresFetchRequest)
            scoreData.scores = scores
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func tapSettings(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSettings", sender: nil)
    }
    @IBAction func tapStartQuiz(_ sender: UIButton) {
            performSegue(withIdentifier: "goToQuiz", sender: nil)
    }
    
    @IBAction func tapListOfBreeds(_ sender: UIButton) {
            performSegue(withIdentifier: "goToListOfBreeds", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToQuiz" {
            guard let qvc = segue.destination as? QuizViewController else { return }
            qvc.allBreeds = allBreeds
            qvc.scoreData = scoreData
            qvc.imageData = imageData
        } else if segue.identifier == "goToListOfBreeds" {
            guard let qvc = segue.destination as? ListOfBreedsViewController else { return }
            qvc.allBreeds = allBreeds
            qvc.imageData = imageData
        } else if segue.identifier == "goToGallerey" {
            guard let gvc = segue.destination as? GallereyViewController else { return }
            gvc.imageData = imageData
        } else if segue.identifier == "goToSettings" {
            guard let svc = segue.destination as? SettingsViewController else { return }
            svc.imageData = imageData
            svc.scoreData = scoreData
        }
    }
    
    // MARK: - The method gets breeds dataBase using API Manager
    private func getAllBreeds() {
        guard let breedsURL = URL(string: "https://api.thecatapi.com/v1/breeds") else { return }
        
        customActivityIndicator.isHidden = false
        statusString.isHidden = false
        animations.startRotateAnimation(imageView: customActivityIndicator, circleTime: 0.7)
        request.getData(into: [Breed].self, from: breedsURL) { parsedData in
            guard let data = parsedData as? [Breed] else { return }
            self.allBreeds = data
            print(self.allBreeds)
            DispatchQueue.main.async {
                self.animations.appearButtonsFromRight(withDuration: 0.7, for: self.buttons)
                print(self.scoreData.scores)
                self.customActivityIndicator.stopAnimating()
                self.customActivityIndicator.isHidden = true
                self.statusString.isHidden = true
            }
        }
    }
    
    @IBAction func unwindToMainController(_ unwindSegue: UIStoryboardSegue) {
    }
}
