//
//  ScoreTableViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 01.10.2023.
//

import UIKit

final class ScoreViewController: UIViewController {
    
    
    @IBOutlet var leaderboardLabel: UILabel!
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var scoreTableView: UITableView!
    private let storageManager = StorageManager.shared
    var playerList: [User]!
    
    
    
    
   
    
    

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

    
    @IBAction func backToMainMenuTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
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
    
    func animateWithFlashEffect(for view: UIView) {
        view.alpha = 0.3
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5.2,
                       options: [.repeat, .autoreverse],
                       animations: {
            
            view.transform = CGAffineTransform(scaleX: 1.01, y: 1)
            
            
            view.alpha = 1
        })
    }
    
}

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "score", for: indexPath)
        let sortedList = playerList.sorted(by: {
            $0.score > $1.score
        })
        let player = sortedList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = player.name
        content.secondaryText = String(player.score)
        content.image = UIImage(systemName: "person.fill")
        content.imageProperties.tintColor = .systemGreen
        
        if let font = UIFont(name: "Copperplate", size: 20) {
            content.textProperties.font = font
            content.textProperties.color = .white
            content.secondaryTextProperties = content.textProperties
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
}

