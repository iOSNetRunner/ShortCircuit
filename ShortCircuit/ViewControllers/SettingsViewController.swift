//
//  SettingsViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import UIKit

enum Skin: CaseIterable {
    case bolt
    case boltcar
    case cloud
    
    var selection: String {
        switch self {
        case .bolt:
            return "bolt.fill"
        case .boltcar:
            return "bolt.car.fill"
        case .cloud:
            return "bolt.horizontal.icloud.fill"
        }
    }
}

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
    private var lastPlayer: User!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 5
        
        
        
        storageManager.read { users in
            switch users {
            case .success(let players):
                self.playerList = players
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        //lastPlayer = playerList.last
        
        
        
        
        checkPlayerSelection()
        checkPlayerSkin()
        
        
        view.setGradientBackground()
        
        setSaveButtonState()
        
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
        guard let newSkin = lastPlayer.skin else { return }
        storageManager.update(lastPlayer, newSkin: newSkin)
        
        
        dismiss(animated: true)
    }
    
    
    
    
    
    private func checkPlayerSelection() {
        if playerList.isEmpty {
            saveButton.isEnabled = false
        } else {
            playerNameLabel.text = playerList.last?.name
            saveButton.isEnabled = true
            
        }
    }
    
    
    private func checkPlayerSkin() {
        guard let player = lastPlayer else { return }
        guard let skin = player.skin else { return }
        playerSkinImage.image = UIImage(systemName: skin)
    }
    
    
    private func setSaveButtonState() {
        
        
        if saveButton.state == .disabled {
            saveButton.backgroundColor = .systemGray
        } else {
            saveButton.backgroundColor = .systemGreen
            
        }
        
        
    }
    
    private func addPlayerMenu() -> UIMenu {
        
//        storageManager.read { users in
//            switch users {
//            case .success(let usernames):
//                self.playerList = usernames
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        
        
        
        var playersMenu: [UIAction] = []
        
        let createPlayer = UIAction(title: "CREATE NEW PLAYER",
                                    image: UIImage(systemName: "plus.circle.fill"),
                                    handler: { _ in
            
            self.createNewPlayer()
            
            
        })
        
        playersMenu.append(createPlayer)
            
            playerList.forEach { player in
                guard let playerName = player.name else { return }
                let item = UIAction(title: playerName,
                                    image: UIImage(systemName: "person.circle.fill"),
                                    handler: { _ in
                    
                    self.lastPlayer = player
                    
                    self.playerNameLabel.text = player.name
                    
                    guard let skin = player.skin else { return }
                    self.playerSkinImage.image = UIImage(systemName: skin)
                    
                    
                    
                    
                })
                
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
            
            self.storageManager.create(inputName) { player in
                self.playerList.append(player)
                self.lastPlayer = player
                self.checkPlayerSelection()
                self.setSaveButtonState()
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
                                         image: UIImage(systemName: Skin.bolt.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.bolt.selection)
                                             self.lastPlayer.skin = Skin.bolt.selection
    
                                         }),
                                
                                UIAction(title: "CAR SKIN",
                                         image: UIImage(systemName: Skin.boltcar.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.boltcar.selection)
                                             self.lastPlayer.skin = Skin.boltcar.selection
                                             
                                         }),
                                
                                UIAction(title: "CLOUD SKIN",
                                         image: UIImage(systemName: Skin.cloud.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.cloud.selection)
                                             self.lastPlayer.skin = Skin.cloud.selection
                                             
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
