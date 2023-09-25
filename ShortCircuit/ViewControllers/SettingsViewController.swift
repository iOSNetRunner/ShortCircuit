//
//  SettingsViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet var playerSettingsLabel: UILabel!
    @IBOutlet var gameSettingsLabel: UILabel!
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerSkinImage: UIImageView!
    @IBOutlet var playerAvatar: UIImageView!
    
    
    @IBOutlet var selectedModeLabel: UILabel!
    
    
    @IBOutlet var selectedObstacleSkin: UIImageView!
    
    
    @IBOutlet var playerSelectButton: UIButton!
    @IBOutlet var skinSelectButton: UIButton!
    @IBOutlet var avatarSelectButton: UIButton!
    
    @IBOutlet var modeSelectButton: UIButton!
    @IBOutlet var obstacleSelectButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    
    
    private let storageManager = StorageManager.shared
    
    private var playerList: [User] = []
    
    
    var gameSpeed = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageManager.read { users in
            switch users {
            case .success(let usernames):
                self.playerList += usernames
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        view.setGradientBackground()
        
        setVisualSettings()
        
        modeSelectButton.menu = addModeMenu()
        modeSelectButton.showsMenuAsPrimaryAction = true
        
        skinSelectButton.menu = addPlayerSkinMenu()
        skinSelectButton.showsMenuAsPrimaryAction = true
        
        obstacleSelectButton.menu = addObstacleSkinMenu()
        obstacleSelectButton.showsMenuAsPrimaryAction = true
        
        playerSelectButton.menu = addPlayerMenu()
        playerSelectButton.showsMenuAsPrimaryAction = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateWithFlashEffect(for: playerSettingsLabel)
        animateWithFlashEffect(for: gameSettingsLabel)
    }
    
    
    @IBAction func gameModeSelectTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
        dismiss(animated: true)
    }
    
    
    
    
    
    
    
    private func setVisualSettings() {
        
        saveButton.backgroundColor = .systemGreen
        
        
        
        
        
        
        saveButton.layer.cornerRadius = 5
        
    }
    
    private func addPlayerMenu() -> UIMenu {
        
        storageManager.read { users in
            switch users {
            case .success(let usernames):
                self.playerList = usernames
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        var playersMenu: [UIAction] = []
        
        let createPlayer = UIAction(title: "CREATE NEW PLAYER",
                                    image: UIImage(systemName: "plus.circle.fill"),
                                    handler: { _ in
            
            self.createNewPlayer()
        })
        
        playersMenu.append(createPlayer)
            
            playerList.forEach { player in
                
                let item = UIAction(title: player.name ?? "uknown user" ,
                                    image: UIImage(systemName: "person.circle.fill"),
                                    handler: { _ in
                    
                    self.playerNameLabel.text = player.name
                }
                )
                
                playersMenu.append(item)
                
            
        }
        
        
        
        return UIMenu(title: "SELECT PLAYER", children: playersMenu)
    }
    
    private func createNewPlayer() {
        
        
        let alert = UIAlertController(title: "Enter your name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let sumbitAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let inputName = alert.textFields?.first?.text else { return }
            self.playerNameLabel.text = inputName
            
            self.storageManager.create(inputName) { username in
                
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(sumbitAction)
        
        present(alert, animated: true)
    }
    
    private func addModeMenu() -> UIMenu {
        let modeMenu = UIMenu(title: "SELECT GAME MODE",
                              options: .displayInline,
                              children: [
                                
                                UIAction(title: "NORMAL",
                                         image: UIImage(systemName: "bolt.fill"),
                                         handler: { _ in
                                             self.selectedModeLabel.text = "NORMAL"
                                         }),
                                
                                UIAction(title: "HARD   X2",
                                         image: UIImage(systemName: "bolt.brakesignal"),
                                         handler: { _ in
                                             self.selectedModeLabel.text = "HARD   X2"
                                         }),
                                
                                UIAction(title: "EXTREME   X3",
                                         image: UIImage(systemName: "bolt.car.fill"),
                                         handler: { _ in
                                             self.selectedModeLabel.text = "EXTREME   X3"
                                         })
                              ])
        
        return modeMenu
    }
    
    private func addPlayerSkinMenu() -> UIMenu {
        let skinMenu = UIMenu(title: "SELECT YOUR SKIN",
                              options: .displayInline,
                              children: [
                                
                                UIAction(title: "BOLT SKIN",
                                         image: UIImage(systemName: "bolt.fill"),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: "bolt.fill")
                                         }),
                                
                                UIAction(title: "CAR SKIN",
                                         image: UIImage(systemName: "bolt.car.fill"),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: "bolt.car.fill")
                                         }),
                                
                                UIAction(title: "CLOUD SKIN",
                                         image: UIImage(systemName: "bolt.horizontal.icloud.fill"),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: "bolt.horizontal.icloud.fill")
                                         })
                              ])
        
        return skinMenu
    }
    
    private func addObstacleSkinMenu() -> UIMenu {
        let obstacleSkinMenu = UIMenu(title: "SELECT OBSTACLE SKIN",
                                      options: .displayInline,
                                      children: [
                                        
                                        UIAction(title: "BATTERYBLOCK",
                                                 image: UIImage(systemName: "bolt.fill.batteryblock.fill"),
                                                 handler: { _ in
                                                     self.selectedObstacleSkin.image = UIImage(systemName: "bolt.fill.batteryblock.fill")
                                                 }),
                                        
                                        UIAction(title: "BOX",
                                                 image: UIImage(systemName: "shippingbox.fill"),
                                                 handler: { _ in
                                                     self.selectedObstacleSkin.image = UIImage(systemName: "shippingbox.fill")
                                                 }),
                                        
                                        UIAction(title: "WATER",
                                                 image: UIImage(systemName: "water.waves"),
                                                 handler: { _ in
                                                     self.selectedObstacleSkin.image = UIImage(systemName: "water.waves")
                                                 })
                                        
                                      ])
        
        return obstacleSkinMenu
    }
    
    
    
}

private extension UIViewController {
    
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
