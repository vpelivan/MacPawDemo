//
//  QuizScoreViewController.swift
//  MacPaw
//
//  Created by Victor Pelivan on 20.05.2020.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import UIKit

class QuizScoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var scoreData = ScoreData()
    var sortedScores: [Score]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        sortedScores = scoreData.scores.sorted { $0.count > $1.count } // Sorting data in tableView by crores decreasing parameter
        tableView.reloadData()
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.hidesBarsWhenVerticallyCompact = false
        if scoreData.scores.isEmpty == true {
            deleteButton.isEnabled = false
        }
    }
    
    //MARK: - The action clears all the score table results
    @IBAction func tapDeleteAll(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Delete All", message: "Are you sure, you want to clear all the results?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.scoreData.scores.removeAll()
            self.tableView.reloadData()
            sender.isEnabled = false
        }
        ac.addAction(cancel)
        ac.addAction(delete)
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - The method returns a string of date in a needed format
    private func getDateFromFormatter(from date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        let str = formatter.string(from: date)
        return str
    }
}

extension QuizScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreData.scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! TopScoreTableViewCell
        let score = sortedScores[indexPath.row]
        cell.scoreLabel.text = "\(score.count) of \(score.questionsCount)"
        cell.dateLabel.text = getDateFromFormatter(from: score.date)
        return cell
    }
}
