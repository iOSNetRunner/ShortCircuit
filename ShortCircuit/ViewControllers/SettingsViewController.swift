//
//  SettingsViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var playerSettingsLabel: UILabel!
    @IBOutlet weak var gameSettingsLabel: UILabel!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerSkinImage: UIImageView!
    @IBOutlet weak var playerAvatar: UIImageView!
    @IBOutlet weak var playerModeLabel: UILabel!
    @IBOutlet weak var playerObstacleSkin: UIImageView!
    
    @IBOutlet weak var playerSelectButton: UIButton!
    @IBOutlet weak var skinSelectButton: UIButton!
    @IBOutlet weak var avatarSelectButton: UIButton!
    @IBOutlet weak var modeSelectButton: UIButton!
    @IBOutlet weak var obstacleSelectButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Private properties
    private let storageManager = StorageManager.shared
    private var playerList: [User] = []
    private var playerNames: [String] {
        var names: [String] = []
        playerList.forEach { player in
            guard let name = player.name else { return }
            names.append(name)
        }
        return names
    }
    
    //MARK: - Other properties
    var lastPlayer: User?
    weak var delegate: SettingsViewControllerDelegate?
    
    override var prefersStatusBarHidden: Bool { true }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return.all
    }
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground()
        setCornerRadius()
        
        loadDataBase()
        
        checkPlayerSelection()
        checkPlayerAvatar()
        checkPlayerSkin()
        checkPlayerMode()
        checkObstacle()
        
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
        setBackButtonState()
    }
    
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        savePlayerSkin()
        savePlayerImage()
        savePlayerMode()
        saveObstacleSkin()
        
        guard let player = lastPlayer else { return }
        delegate?.setCurrentPlayer(player)
        
        dismiss(animated: true)
    }

    @IBAction func importImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
    
    
    //MARK: - Check player parameters
    private func checkPlayerSelection() {
        if playerList.isEmpty {
            backButton.isEnabled = false
        } else {
            guard let player = lastPlayer else { return }
            playerNameLabel.text = player.name
            backButton.isEnabled = true
        }
    }
    
    private func checkPlayerSkin() {
        guard let player = lastPlayer else { return }
        guard let skin = player.skin else { return }
        playerSkinImage.image = UIImage(systemName: skin)
    }
    
    private func checkPlayerAvatar() {
        guard let player = lastPlayer else { return }
        guard let dataPath = player.avatar else { return playerAvatar.image = nil }
        playerAvatar.image = UIImage(contentsOfFile: dataPath)
    }
    
    private func checkPlayerMode() {
        guard let player = lastPlayer else { return }
        var gameMode: String {
            switch player.speed {
            case Mode.hard.speed: return Mode.hard.selection
            case Mode.extreme.speed: return Mode.extreme.selection
            default: return Mode.normal.selection
            }
        }
        playerModeLabel.text = gameMode
    }
    
    private func checkObstacle() {
        guard let player = lastPlayer else { return }
        guard let obstacle = player.obstacle else { return }
        playerObstacleSkin.image = UIImage(systemName: obstacle)
    }
    
    private func setBackButtonState() {
        if backButton.state == .disabled {
            backButton.backgroundColor = .systemGray
        } else {
            backButton.backgroundColor = .systemGreen
        }
    }
    
    private func setCornerRadius() {
        backButton.layer.cornerRadius = 5
        playerAvatar.layer.cornerRadius = playerAvatar.frame.width / 2
    }
    
    
    //MARK: - UIMenu implementation
    private func addPlayerMenu() -> UIMenu {
        var playersMenu: [UIAction] = []
        
        let createPlayer = UIAction(title: Menu.createNewPlayer,
                                    image: UIImage(systemName: Menu.createIcon),
                                    handler: { _ in
            self.createNewPlayer()
            self.playerSkinImage.image = UIImage(systemName: Skin.bolt.selection)
            self.playerAvatar.image = nil
            self.playerModeLabel.text = Mode.normal.selection
            self.playerObstacleSkin.image = UIImage(systemName: Obstacle.battery.selection)
        })
        
        playersMenu.append(createPlayer)
        
        
        playerList.forEach { player in
            guard let playerName = player.name else { return }
            let item = UIAction(title: playerName,
                                image: UIImage(systemName: Menu.createIcon),
                                handler: { _ in
                
                self.lastPlayer = player
                self.playerNameLabel.text = player.name
                self.checkPlayerMode()
                self.checkPlayerSkin()
                self.checkObstacle()
                self.checkPlayerAvatar()
            })
            
            playersMenu.append(item)
        }
        return UIMenu(title: Menu.selectPlayer, children: playersMenu)
    }
    
    private func createNewPlayer() {
        let alert = UIAlertController(title: Alert.createTitle,
                                      message: Alert.createMessage,
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.delegate = self
        
        let cancelAction = UIAlertAction(title: Alert.cancel, style: .destructive)
        let sumbitAction = UIAlertAction(title: Alert.save, style: .default) { _ in
            
            guard let inputName = alert.textFields?.first?.text else { return }
            guard inputName != "" else {
                return AlertHelper.showAlert(title: Alert.errorTitle, message: Alert.errorMessage, over: self)
            }
            guard !self.playerNames.contains(inputName) else {
                return AlertHelper.showAlert(title: Alert.errorTitle, message: Alert.duplicateMessage, over: self)
            }
            self.playerNameLabel.text = inputName
            
            self.storageManager.create(inputName) { player in
                self.playerList.append(player)
                self.lastPlayer = player
                self.checkPlayerSelection()
                self.setBackButtonState()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(sumbitAction)
        
        present(alert, animated: true)
    }
    
    private func addPlayerSkinMenu() -> UIMenu {
        let skinMenu = UIMenu(title: Menu.selectPlayerSkin,
                              options: .displayInline,
                              children: [
                                
                                UIAction(title: Skin.bolt.actionTitle,
                                         image: UIImage(systemName: Skin.bolt.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.bolt.selection)
                                             self.lastPlayer?.skin = Skin.bolt.selection
                                             
                                         }),
                                
                                UIAction(title: Skin.boltcar.actionTitle,
                                         image: UIImage(systemName: Skin.boltcar.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.boltcar.selection)
                                             self.lastPlayer?.skin = Skin.boltcar.selection
                                             
                                         }),
                                
                                UIAction(title: Skin.cloud.actionTitle,
                                         image: UIImage(systemName: Skin.cloud.selection),
                                         handler: { _ in
                                             self.playerSkinImage.image = UIImage(systemName: Skin.cloud.selection)
                                             self.lastPlayer?.skin = Skin.cloud.selection
                                             
                                         })
                              ])
        return skinMenu
    }
    
    private func addModeMenu() -> UIMenu {
        let modeMenu = UIMenu(
            title: Menu.mode,
            options: .displayInline,
            children: [
                
                UIAction(title: Mode.normal.selection,
                         image: UIImage(systemName: Menu.boltFill),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.normal.selection
                             self.lastPlayer?.speed = Mode.normal.speed
                         }),
                
                UIAction(title: Mode.hard.selection,
                         image: UIImage(systemName: Menu.boltSignal),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.hard.selection
                             self.lastPlayer?.speed = Mode.hard.speed
                         }),
                
                UIAction(title: Mode.extreme.selection,
                         image: UIImage(systemName:  Menu.boltCar),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.extreme.selection
                             self.lastPlayer?.speed = Mode.extreme.speed
                         })
            ])
        
        return modeMenu
    }
    
    private func addObstacleSkinMenu() -> UIMenu {
        let obstacleSkinMenu = UIMenu(
            title: Menu.selectObstacle,
            options: .displayInline,
            children: [
                
                UIAction(title: Obstacle.battery.actionTitle,
                         image: UIImage(systemName: Obstacle.battery.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.battery.selection)
                             self.lastPlayer?.obstacle = Obstacle.battery.selection
                         }),
                
                UIAction(title: Obstacle.box.actionTitle,
                         image: UIImage(systemName: Obstacle.box.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.box.selection)
                             self.lastPlayer?.obstacle = Obstacle.box.selection
                         }),
                
                UIAction(title: Obstacle.water.actionTitle,
                         image: UIImage(systemName: Obstacle.water.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.water.selection)
                             self.lastPlayer?.obstacle = Obstacle.water.selection
                         })
            ])
        
        return obstacleSkinMenu
    }
    
    
    //MARK: - CoreData methods
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
    
    private func savePlayerImage() {
        let filename = UUID()
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        guard let imageData = playerAvatar.image?.pngData() else { return }
        
        let fileURL = documents.appendingPathComponent(filename.uuidString)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        do {
            try imageData.write(to: fileURL)
            guard let player = lastPlayer else { return }
            storageManager.update(player, newPic: fileURL.path)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func savePlayerSkin() {
        guard let player = lastPlayer else { return }
        guard let newSkin = player.skin else {
            storageManager.update(player, newSkin: Skin.bolt.selection)
            return
        }
        
        storageManager.update(player, newSkin: newSkin)
    }
    
    private func savePlayerMode() {
        guard let player = lastPlayer else { return }
        storageManager.update(player, newMode: player.speed)
    }
    
    private func saveObstacleSkin() {
        guard let player = lastPlayer else { return }
        guard let newObstacle = player.obstacle else {
            storageManager.update(player, newObstacle: Obstacle.battery.selection)
            return
        }
        storageManager.update(player, newObstacle: newObstacle)
    }
    
}

//MARK: - Extensions
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 9 {
            textField.text = ""
        }
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        playerAvatar.image = image.fixOrientation()
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
