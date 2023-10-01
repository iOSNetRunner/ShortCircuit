//
//  SettingsViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 24.09.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var playerSettingsLabel: UILabel!
    @IBOutlet var gameSettingsLabel: UILabel!
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerSkinImage: UIImageView!
    @IBOutlet var playerAvatar: UIImageView!
    @IBOutlet var playerModeLabel: UILabel!
    @IBOutlet var playerObstacleSkin: UIImageView!
    
    @IBOutlet var playerSelectButton: UIButton!
    @IBOutlet var skinSelectButton: UIButton!
    @IBOutlet var avatarSelectButton: UIButton!
    @IBOutlet var modeSelectButton: UIButton!
    @IBOutlet var obstacleSelectButton: UIButton!
    
    @IBOutlet var saveAndExitButton: UIButton!
    
    //MARK: - Private properties
    private let storageManager = StorageManager.shared
    private var playerList: [User] = []
    
    //MARK: - Other properties
    var lastPlayer: User!
    unowned var delegate: SettingsViewControllerDelegate!
    
    override var prefersStatusBarHidden: Bool { true }
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return.all
    }
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground()
        saveAndExitButton.layer.cornerRadius = 5
        playerAvatar.layer.cornerRadius = playerAvatar.frame.width / 2
        
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
        setSaveButtonState()
    }
    
    
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        savePlayerSkin()
        savePlayerImage()
        savePlayerMode()
        saveObstacleSkin()
        delegate.setCurrentPlayer(lastPlayer)
        
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
            saveAndExitButton.isEnabled = false
        } else {
            playerNameLabel.text = lastPlayer.name
            saveAndExitButton.isEnabled = true
        }
    }
    
    private func checkPlayerSkin() {
        guard let player = lastPlayer else { return }
        guard let skin = player.skin else { return }
        playerSkinImage.image = UIImage(systemName: skin)
    }
    
    private func checkPlayerAvatar() {
        guard let player = lastPlayer else { return }
        guard let dataPath = player.avatar else { return }
        playerAvatar.image = UIImage(contentsOfFile: dataPath)
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
        playerModeLabel.text = gameMode
    }
    
    private func checkObstacle() {
        guard let player = lastPlayer else { return }
        guard let obstacle = player.obstacle else { return }
        playerObstacleSkin.image = UIImage(systemName: obstacle)
    }
    
    private func setSaveButtonState() {
        if saveAndExitButton.state == .disabled {
            saveAndExitButton.backgroundColor = .systemGray
        } else {
            saveAndExitButton.backgroundColor = .systemGreen
        }
    }
    
    
    //MARK: - UIMenu implementation
    private func addPlayerMenu() -> UIMenu {
        var playersMenu: [UIAction] = []
        
        let createPlayer = UIAction(title: "CREATE NEW PLAYER",
                                    image: UIImage(systemName: "plus.circle.fill"),
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
                                image: UIImage(systemName: "person.circle.fill"),
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
        return UIMenu(title: "SELECT PLAYER", children: playersMenu)
    }
    
    private func createNewPlayer() {
        let alert = UIAlertController(title: "Enter your name",
                                      message: "10 characters max",
                                      preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.delegate = self
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let sumbitAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let inputName = alert.textFields?.first?.text else { return }
            guard inputName != "" else { return }
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
    
    private func addModeMenu() -> UIMenu {
        let modeMenu = UIMenu(
            title: "SELECT GAME MODE",
            options: .displayInline,
            children: [
                
                UIAction(title: Mode.normal.selection,
                         image: UIImage(systemName: "bolt.fill"),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.normal.selection
                             self.lastPlayer.speed = Mode.normal.speed
                         }),
                
                UIAction(title: Mode.hard.selection,
                         image: UIImage(systemName: "bolt.brakesignal"),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.hard.selection
                             self.lastPlayer.speed = Mode.hard.speed
                         }),
                
                UIAction(title: Mode.extreme.selection,
                         image: UIImage(systemName: "bolt.car.fill"),
                         handler: { _ in
                             self.playerModeLabel.text = Mode.extreme.selection
                             self.lastPlayer.speed = Mode.extreme.speed
                         })
            ])
        
        return modeMenu
    }
    
    private func addObstacleSkinMenu() -> UIMenu {
        let obstacleSkinMenu = UIMenu(
            title: "SELECT OBSTACLE SKIN",
            options: .displayInline,
            children: [
                
                UIAction(title: Obstacle.battery.actionTitle,
                         image: UIImage(systemName: Obstacle.battery.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.battery.selection)
                             self.lastPlayer.obstacle = Obstacle.battery.selection
                         }),
                
                UIAction(title: Obstacle.box.actionTitle,
                         image: UIImage(systemName: Obstacle.box.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.box.selection)
                             self.lastPlayer.obstacle = Obstacle.box.selection
                         }),
                
                UIAction(title: Obstacle.water.actionTitle,
                         image: UIImage(systemName: Obstacle.water.selection),
                         handler: { _ in
                             self.playerObstacleSkin.image = UIImage(systemName: Obstacle.water.selection)
                             self.lastPlayer.obstacle = Obstacle.water.selection
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
        guard let filename = lastPlayer.name else { return }
        guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        guard let imageData = playerAvatar.image?.pngData() else { return }
        
        let fileURL = documents.appendingPathComponent("\(filename).png")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("Couldn't remove the file at path", error.localizedDescription)
            }
        }
        
        do {
            try imageData.write(to: fileURL)
            storageManager.update(lastPlayer, newPic: fileURL.path)
            
        } catch {
            print("ERROR saving file", error.localizedDescription)
        }
    }
    
    private func savePlayerSkin() {
        guard let newSkin = lastPlayer.skin else {
            storageManager.update(lastPlayer, newSkin: Skin.bolt.selection)
            return
        }
        
        storageManager.update(lastPlayer, newSkin: newSkin)
    }
    
    private func savePlayerMode() {
        storageManager.update(lastPlayer, newMode: lastPlayer.speed)
    }
    
    private func saveObstacleSkin() {
        guard let newObstacle = lastPlayer.obstacle else {
            storageManager.update(lastPlayer, newObstacle: Obstacle.battery.selection)
            return
        }
        storageManager.update(lastPlayer, newObstacle: newObstacle)
    }
    
    
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 9 { textField.text = "" }
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
