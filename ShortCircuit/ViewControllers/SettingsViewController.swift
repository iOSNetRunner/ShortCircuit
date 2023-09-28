//
//  SettingsViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import UIKit

enum Skin {
    case bolt
    case boltcar
    case cloud
    
    var actionTitle: String {
        switch self {
        case .bolt:
            return "BOLT SKIN"
        case .boltcar:
            return "CAR SKIN"
        case .cloud:
            return "CLOUD SKIN"
        }
    }
    
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

enum Mode {
    case normal
    case hard
    case extreme
    
    var selection: String {
        switch self {
            
        case .normal:
            return "normal"
        case .hard:
            return "hard x2"
        case .extreme:
            return "extreme x3"
        }
    }
    
    var speed: Int64 {
        switch self {
        case .normal:
            return 3
        case .hard:
            return 2
        case .extreme:
            return 1
        }
    }
}

enum Obstacle {
    case battery
    case box
    case water
    
    var actionTitle: String {
        switch self {
        case .battery:
            return "BATTERYBLOCK"
        case .box:
            return "BOX"
        case .water:
            return "WATER"
        }
    }
    
    var selection: String {
        switch self {
        case .battery:
            return "bolt.fill.batteryblock.fill"
        case .box:
            return "shippingbox.fill"
        case .water:
            return "water.waves"
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
        
        
        lastPlayer = playerList.last
        
//        playerList.forEach { user in
//            print(user.name)
//        }
//        print()
        
        checkPlayerSelection()
        checkPlayerSkin()
        checkPlayerMode()
        checkObstacle()
        
        
        
        view.setGradientBackground()
        
        
        
        modeSelectButton.menu = addModeMenu()
        modeSelectButton.showsMenuAsPrimaryAction = true
        
        skinSelectButton.menu = addPlayerSkinMenu()
        skinSelectButton.showsMenuAsPrimaryAction = true
        
        obstacleSelectButton.menu = addObstacleSkinMenu()
        obstacleSelectButton.showsMenuAsPrimaryAction = true
        
        playerSelectButton.showsMenuAsPrimaryAction = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        animateWithFlashEffect(for: playerSettingsLabel)
        animateWithFlashEffect(for: gameSettingsLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerSelectButton.menu = addPlayerMenu()
        
        
        
        
        setSaveButtonState()
    }
    
    
    
    @IBAction func gameModeSelectTapped(_ sender: Any) {
        
    }
    
    private func savePlayerSkin() {
        guard let newSkin = lastPlayer.skin else {
            storageManager.update(lastPlayer, newSkin: Skin.bolt.selection)
            return
        }
        
        storageManager.update(lastPlayer, newSkin: newSkin)
    }
    
    private func saveObstacleSkin() {
        guard let newObstacle = lastPlayer.obstacle else {
            storageManager.update(lastPlayer, newObstacle: Obstacle.battery.selection)
            return
        }
        storageManager.update(lastPlayer, newObstacle: newObstacle)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        
        storageManager.update(lastPlayer, newMode: lastPlayer.speed)
        
        
        
        savePlayerSkin()
        saveObstacleSkin()
        
        

        
        
        //print(lastPlayer)
        
        
        
        
    }
    
    
    
    
    
    
    
    private func checkPlayerSelection() {
        if playerList.isEmpty {
            saveButton.isEnabled = false
        } else {
            // change this to user which will come from previous screen 28.09 02:09 |
            playerNameLabel.text = playerList.last?.name
// 1st screen -> var User! -> guard User & pass data to settings. If no User - do not init.
// NO USER -> SETTINGS -> USER create -> SAVE BUTTON -> PASSES USER TO 1 screen
// var User Loads -> Settings -> var lastPlayer = selectedUser
            
            
            
            saveButton.isEnabled = true
            
        }
    }
    
    
    private func checkPlayerSkin() {
        guard let player = lastPlayer else { return }
        guard let skin = player.skin else { return }
        playerSkinImage.image = UIImage(systemName: skin)
    }
    
    
    private func checkPlayerMode() {
        guard let player = lastPlayer else { return }
        var gameMode: String {
            switch player.speed {
                case 2: return Mode.hard.selection
                case 1: return Mode.extreme.selection
                default: return Mode.normal.selection
            }
        }
        selectedModeLabel.text = gameMode
    }
    
    private func checkObstacle() {
        guard let player = lastPlayer else { return }
        guard let obstacle = player.obstacle else { return }
        selectedObstacleSkin.image = UIImage(systemName: obstacle)
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
//            case .success(let players):
//                self.playerList = players
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
                    self.checkPlayerMode()
                    
                    self.checkPlayerSkin()
                    self.checkObstacle()
                    
                    self.searchPlayer(player)
                    
                    
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
        let modeMenu = UIMenu(
            title: "SELECT GAME MODE",
            options: .displayInline,
            children: [
                
                UIAction(title: Mode.normal.selection,
                         image: UIImage(systemName: "bolt.fill")?.withTintColor(.systemYellow),
                         handler: { _ in
                             self.selectedModeLabel.text = Mode.normal.selection
                             self.lastPlayer.speed = Mode.normal.speed
                         }),
                
                UIAction(title: Mode.hard.selection,
                         image: UIImage(systemName: "bolt.brakesignal"),
                         handler: { _ in
                             self.selectedModeLabel.text = Mode.hard.selection
                             self.lastPlayer.speed = Mode.hard.speed
                         }),
                
                UIAction(title: Mode.extreme.selection,
                         image: UIImage(systemName: "bolt.car.fill"),
                         handler: { _ in
                             self.selectedModeLabel.text = Mode.extreme.selection
                             self.lastPlayer.speed = Mode.extreme.speed
                         })
            ])
        
        return modeMenu
    }
    
    private func addPlayerSkinMenu() -> UIMenu {
        let skinMenu = UIMenu(title: "SELECT YOUR SKIN",
                              options: .displayInline,
                              children: [
                                
                                UIAction(title: Skin.bolt.actionTitle,
                                         image: UIImage(systemName: Skin.bolt.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.bolt.selection)
                                             self.lastPlayer.skin = Skin.bolt.selection
    
                                         }),
                                
                                UIAction(title: Skin.boltcar.actionTitle,
                                         image: UIImage(systemName: Skin.boltcar.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.boltcar.selection)
                                             self.lastPlayer.skin = Skin.boltcar.selection
                                             
                                         }),
                                
                                UIAction(title: Skin.cloud.actionTitle,
                                         image: UIImage(systemName: Skin.cloud.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.cloud.selection)
                                             self.lastPlayer.skin = Skin.cloud.selection
                                             
                                         })
                              ])
        
        return skinMenu
    }
    
    private func addObstacleSkinMenu() -> UIMenu {
        let obstacleSkinMenu = UIMenu(
            title: "SELECT OBSTACLE SKIN",
            options: .displayInline,
            children: [
                
                UIAction(title: Obstacle.battery.actionTitle,
                         image: UIImage(systemName: Obstacle.battery.selection),
                         handler: { _ in
                             self.selectedObstacleSkin.image = UIImage(systemName: Obstacle.battery.selection)
                             self.lastPlayer.obstacle = Obstacle.battery.selection
                         }),
                
                UIAction(title: Obstacle.box.actionTitle,
                         image: UIImage(systemName: Obstacle.box.selection),
                         handler: { _ in
                             self.selectedObstacleSkin.image = UIImage(systemName: Obstacle.box.selection)
                             self.lastPlayer.obstacle = Obstacle.box.selection
                         }),
                
                UIAction(title: Obstacle.water.actionTitle,
                         image: UIImage(systemName: Obstacle.water.selection),
                         handler: { _ in
                             self.selectedObstacleSkin.image = UIImage(systemName: Obstacle.water.selection)
                             self.lastPlayer.obstacle = Obstacle.water.selection
                         })
                
            ])
        
        return obstacleSkinMenu
    }
    
    
    func searchPlayer(_ player: User) {
        playerList.forEach { user in
            if user.name == player.name {
                guard let index = playerList.firstIndex(of: user) else { return }
                let playerToMove = playerList.remove(at: index)
                playerList.append(playerToMove)
                
                
                
                playerList.forEach { user in
                    print(user.name)
                    print()
                }
            }
        }
        
        
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
