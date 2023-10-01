//
//  MainViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func setCurrentPlayer(_ player: User)
}

final class MainViewController: UIViewController {

    
    @IBOutlet var arrowsImage: UIImageView!
    @IBOutlet var gearLogo: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var boltLogo: UIImageView!
    @IBOutlet var playerSelectionLabel: UILabel!
    
    private let storageManager = StorageManager.shared
    private var animationTimer: Timer?
    
    var currentPlayer: User!
    var playerList: [User] = []

    override var prefersStatusBarHidden: Bool { true }
    
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLastSelectedPlayer()

        view.setGradientBackground()
        
        
        animationTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                          target: self,
                                          selector: #selector(animateBackground),
                                          userInfo: nil,
                                          repeats: true)
        
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkCurrentPlayer()
        
        
        
        animateBackground()
        animateTitle()
        animateArrows()
        animateBackgroundGear()
        animateBolt()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        titleLabel.transform = CGAffineTransform.identity
//        boltLogo.transform = CGAffineTransform.identity
    }
    
    private func loadLastSelectedPlayer() {
        storageManager.read { users in
            switch users {
            case .success(let players):
                self.playerList = players
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        guard !playerList.isEmpty else { return }
        playerList.forEach { player in
            if player.lastSelected {
                currentPlayer = player
            }
        }
    }
    
    
    private func checkCurrentPlayer() {
        if currentPlayer != nil {
            startButton.isEnabled = true
            playerSelectionLabel.text = currentPlayer?.name
            playerSelectionLabel.textColor = .systemYellow
        } else {
            startButton.isEnabled = false
            startButton.setTitleColor(.gray, for: .disabled)
            
        }
    }
    
    @objc private func animateBackground() {
        let spawnPoint = CGFloat.random(in: view.bounds.minX...view.bounds.maxX)
        let frameSide = CGFloat.random(in: 10...70)
        
        let bolt = UIImageView(frame: CGRect(x: spawnPoint,
                                                  y: view.bounds.minY,
                                                  width: frameSide,
                                                  height: frameSide))
        bolt.image = UIImage(systemName: "bolt.fill")
        bolt.tintColor = .systemGreen
        
        bolt.layer.shadowColor = bolt.tintColor.cgColor
        bolt.layer.shadowOpacity = 1
        bolt.layer.shadowRadius = 10
        
        view.insertSubview(bolt, at: .max)
        
        UIView.animate(withDuration: 5,
                       delay: 0,
                       usingSpringWithDamping: 3.1,
                       initialSpringVelocity: 0.1,
                       options: [ .curveEaseInOut],
                       animations: {
            bolt.frame = bolt.frame.offsetBy(dx: spawnPoint, dy: self.view.bounds.maxY)
            bolt.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            bolt.alpha = Double.random(in: 0.2...1)
        }, completion: { _ in
            bolt.removeFromSuperview()
        })
    }
    
    private func animateTitle() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5.2,
                       options: [.repeat, .autoreverse],
                       animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
        })
    }
    
    private func animateBolt() {
        self.boltLogo.alpha = 0.05
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5.2,
                       options: [.repeat, .curveLinear],
                       animations: {
            
            self.boltLogo.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            
            self.boltLogo.alpha = Double.random(in: 0.2...1)
        })
    }
    
    private func animateArrows() {
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: [.repeat, .curveLinear],
                       animations: {
            self.arrowsImage.transform = CGAffineTransformMakeRotation(.pi)
            self.arrowsImage.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    private func animateBackgroundGear() {
        UIView.animate(withDuration: 3.0,
                       delay: 0,
                       
                       options: [.repeat, .curveLinear],
                       animations: {
            self.gearLogo.transform = CGAffineTransformMakeRotation(.pi * 0.66)
            self.gearLogo.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "start":
            guard let gameVC = segue.destination as? GameViewController else { return }
            gameVC.currentPlayer = currentPlayer
        case "leaderboard":
            guard let scoreVC = segue.destination as? ScoreViewController else { return }
            scoreVC.playerList = playerList
        case "settings":
            guard let settingsVC = segue.destination as? SettingsViewController else { return }
                    settingsVC.delegate = self
            guard (currentPlayer != nil) else { return }
            settingsVC.lastPlayer = currentPlayer
        case .none:
            return
        case .some(_):
            return
        }
        
        
        
        
        
        
        
    }
    

}

extension MainViewController: SettingsViewControllerDelegate {
    func setCurrentPlayer(_ player: User) {
        if currentPlayer != nil {
            storageManager.updateLastSelection(previousUser: currentPlayer, newUser: player)
        }
        currentPlayer = player
        storageManager.updateLastSelection(newUser: player)
    }
    
    
}
