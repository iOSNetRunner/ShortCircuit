//
//  ScoreTableViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 01.10.2023.
//

import UIKit

final class ScoreViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var leaderboardLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var scoreTableView: UITableView!
    
    //MARK: - Properties
    private let storageManager = StorageManager.shared
    var playerList: [User]?
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground()
        setVisualSettings()
        
        scoreTableView.dataSource = self
        scoreTableView.delegate = self

        loadDataBase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateWithFlashEffect(for: leaderboardLabel)
    }

    //MARK: - IBActions
    @IBAction func backToMainMenuTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Flow
    private func loadDataBase() {
        storageManager.read { users in
            switch users {
            case .success(let players):
                self.playerList = players
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setVisualSettings() {
        scoreTableView.backgroundColor = .clear
        exitButton.layer.cornerRadius = 5
    }
    
    
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = playerList else { return .zero }
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as? ScoreTableViewCell else { return UITableViewCell() }
        
        guard let list = playerList else { return UITableViewCell() }
        
        let sortedList = list.sorted(by: { $0.score > $1.score })
        
        cell.configure(with: sortedList[indexPath.row].name, and: sortedList[indexPath.row].score)
        
        return cell
    }
}
