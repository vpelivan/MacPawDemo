//
//  QuizController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 18.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class QuizViewController: UITableViewController{
    
    @IBOutlet var buttons: [BlackButton]! //Custom Class
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var containerView: UIView! // A container for catImageView to set borders and rounded corners with shadows
    @IBOutlet weak var customActivityIndicator: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet var addButton: [UIButton]! //the animation methods require all buttons to be in outlet collection
    
    var allBreeds: [Breed] = [] // All Cats Database
    var scoreData = ScoreData() // All Top Scores From Quiz
    var imageData = ImageData()
    var currentScore = Score(context: PersistenceSerive.context) // The score of correct answers
    let animations = Animations()
    let request = NetworkService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScore.count = 0
        currentScore.questionsCount = 0
        currentScore.date = Date()
        tableView.tableFooterView = UIView(frame: .zero)
        customActivityIndicator.isHidden = true
        totalScoreLabel.text = "Total Score: \(currentScore.count) of \(currentScore.questionsCount)"
        shuffleBreeds()
        for button in self.buttons { //user must not interact with buttons until the image is loaded
            button.isEnabled = false
        }
        performQuestionRequest()
        randomizeButtons()
        containerView.setShadowsAndCorners()
        catImageView.setRadiusAndBounds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animations.appearButtonsFromRight(withDuration: 0.7, for: buttons)
        print(scoreData.scores)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manageScoreResults()
    }
    
    @IBAction func tapAddToGallerey(_ sender: UIButton) {
        guard let image = catImageView.image else { return }
        imageData.images.append(image)
        
        sender.isEnabled = false
        animations.dissappearButtonsWithFade(withDuration: 0.8, for: addButton)
    }
    
    //MARK: - In the next IBAction we create a group in GCD to perform some events one after another
    @IBAction func pushButton(_ sender: BlackButton) {
        let group = DispatchGroup()
        DispatchQueue.global().async { // I've placed all actions in a global queue
            group.enter() // first group
            DispatchQueue.main.async { // we must interact with interface elements through main queue
                self.performQuizLogic(with: sender)
                group.leave()
            }
            sleep(1) //lets the button colored to green or red to stay for one second so the user might see if it is a correct answer in quiz or not
            group.enter() //third group
            DispatchQueue.main.async { //interacting with interface elements through main queue
                self.animations.dissappearButtonsWithFade(withDuration: 1.0, for: self.buttons)
                group.leave()
            }
            sleep(1) //lets fade animation to be executed (for some reasons, haven't found a way to perform @escaping completion handler in this animation, group.leave() is a bad execution signal in closer)
            group.enter() //fourth group
            if self.allBreeds.count > 1 {
                self.allBreeds.removeFirst() //we remove the first element, and the next breed becomes first
            } else {
                // need to perform win alert here, when all breeds exceed
            }
            DispatchQueue.main.async {
                self.performQuestionRequest()
                self.randomizeButtons()
                for button in self.buttons {
                    button.setForAnimations()
                }
                self.animations.appearButtonsFromRight(withDuration: 0.7, for: self.buttons)
                group.leave()
            }
        }
    }
    
    @IBAction func tapScoreButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToScore", sender: nil)
    }

    //MARK: Shows alert controller when the quiz is finished
    private func showWonAlert() {
        let ac = UIAlertController(title: "Congratulations!", message: "You have just finished the quiz with score result: \(currentScore.count) correct answers from \(currentScore.questionsCount) questions", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - The method sets titles for buttons using randomizer
    private func randomizeButtons() {
        var allBreedsForRandom = allBreeds
        
        let correctButtonIndex = arc4random_uniform(UInt32(buttons.count - 1))
        guard let correctAnswer = allBreeds.first?.name else { return }
        allBreedsForRandom.removeFirst() // to avoid same result as the correct answer
        for i in 0...3 {
            guard allBreedsForRandom.count >= 3 else {
                showWonAlert()
                return
            }
            if i == correctButtonIndex {
                self.buttons[i].setTitle(correctAnswer, for: .normal)
            } else {
                let randomBreed = arc4random_uniform(UInt32(allBreedsForRandom.count - 1))
                let randomBreedIndex = Int(randomBreed)
                let randomBreedName = allBreedsForRandom[randomBreedIndex].name
                allBreedsForRandom.remove(at: randomBreedIndex) // To avoid same results
                self.buttons[i].setTitle(randomBreedName, for: .normal)
            }
        }
    }
    
    //MARK: - This method shuffles all the breeds in breeds array using arc4random
    private func shuffleBreeds() {
        var shuffledBreeds = [Breed]()
        
        for _ in 0..<allBreeds.count
        {
            let rand = Int(arc4random_uniform(UInt32(allBreeds.count)))
            shuffledBreeds.append(allBreeds[rand])
            allBreeds.remove(at: rand) // removing randomly generated element to avoid repeating results
        }
        allBreeds = shuffledBreeds
    }
    
    //MARK: - The function performs next breed picture request
    private func performQuestionRequest() {
        catImageView.image = nil
        addButton[0].isHidden = true
        addButton[0].alpha = 1.0
        customActivityIndicator.isHidden = false
        animations.startRotateAnimation(imageView: customActivityIndicator, circleTime: 0.7)
        guard let id = allBreeds.first?.id else { return }
        guard let catURL = URL(string: "https://api.thecatapi.com/v1/images/search?breed_id=\(id)") else { return }
        request.getData(into: [CatModel].self, from: catURL) { (data) in
            guard let catData = data as? [CatModel],
                let imageURLString = catData.first?.url,
                let imageURL = URL(string: imageURLString)
                else { return }
            self.request.downloadImage(from: imageURL) { (image) in
                DispatchQueue.main.async {
                    self.catImageView.image = image
                    self.customActivityIndicator.isHidden = true
                    self.customActivityIndicator.stopAnimating()
                    self.addButton[0].setAddButton()
                    for button in self.buttons {
                        button.isEnabled = true
                    }
                }
            }
        }
    }
    
    //MARK: - All the scoring logic should be in this function
    private func performQuizLogic(with sender: UIButton) {
        for button in buttons {
            button.isEnabled = false
        }
        if sender.titleLabel?.text == allBreeds.first?.name {
            sender.layer.backgroundColor = #colorLiteral(red: 0.1280779076, green: 0.8463880806, blue: 0.004566072137, alpha: 1)
            currentScore.count += 1
        } else {
            sender.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            for button in buttons {
                if button.titleLabel?.text == self.allBreeds.first?.name {
                    button.layer.backgroundColor = #colorLiteral(red: 0.1280779076, green: 0.8463880806, blue: 0.004566072137, alpha: 1)
                }
            }
        }
        currentScore.questionsCount += 1
        totalScoreLabel.text = "Total Score: \(currentScore.count) of \(currentScore.questionsCount)"
    }
    
    //MARK: - The method compares current result with all top results, and adds new values in scores array if necessary
    private func manageScoreResults() {
        
        if currentScore.count == 0 {
            return
        }
        if scoreData.scores.isEmpty == true {
            scoreData.scores.append(currentScore)
            PersistenceSerive.saveContext()
            return
        }
        for i in 0...scoreData.scores.count - 1 {
            if scoreData.scores[i].date == currentScore.date {
                scoreData.scores[i] = currentScore
                return
            }
        }
        if scoreData.scores.count < 10 {
            scoreData.scores.append(currentScore)
            PersistenceSerive.saveContext()
            return
        }
        for score in scoreData.scores {
            if currentScore.count > score.count {
                scoreData.scores.removeLast()
                scoreData.scores.append(currentScore)
                PersistenceSerive.saveContext()
                break
            }
        }
    }    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToScore" {
            guard let svc = segue.destination as? QuizScoreViewController else { return }
            manageScoreResults()
            svc.scoreData = scoreData
        } else if segue.identifier == "goToZoom" {
            guard let zvc = segue.destination as? ZoomImageViewController, let image = catImageView.image else { return }
            zvc.image = image
        }
    }
    
    // MARK: - Table view data source, as we are using static cells we don't need delegate methods in this case
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if catImageView.image != nil && indexPath.row == 0 {
            performSegue(withIdentifier: "goToZoom", sender: nil)
        }
    }
    
}
