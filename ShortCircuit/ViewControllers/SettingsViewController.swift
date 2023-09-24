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
    
    
    
    
    var gameSpeed = 3
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground()
        
        modeSelectButton.menu = addModeMenu()
        modeSelectButton.showsMenuAsPrimaryAction = true
        
        skinSelectButton.menu = addPlayerSkinMenu()
        skinSelectButton.showsMenuAsPrimaryAction = true
        
        obstacleSelectButton.menu = addObstacleSkinMenu()
        obstacleSelectButton.showsMenuAsPrimaryAction = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateWithFlashEffect(for: playerSettingsLabel)
        animateWithFlashEffect(for: gameSettingsLabel)
    }
    
    
    @IBAction func gameModeSelectTapped(_ sender: Any) {
        
    }
    
    
    private func addModeMenu() -> UIMenu {
        let modeMenu = UIMenu(title: "SELECT GAME MODE",
                              options: .displayInline,
                              children: [
        
            UIAction(title: "NORMAL",
                     image: UIImage(systemName: "bolt.fill"),
                     handler: { _ in
                print("NORMAL MODE SELECTED")
            }),
            
            UIAction(title: "HARD X2",
                     image: UIImage(systemName: "bolt.brakesignal"),
                     handler: { _ in
                print("HARD MODE SELECTED")
            }),
            
            UIAction(title: "EXTREME X3",
                     image: UIImage(systemName: "bolt.car.fill"),
                     handler: { _ in
                print("EXTREME MODE SELECTED")
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
