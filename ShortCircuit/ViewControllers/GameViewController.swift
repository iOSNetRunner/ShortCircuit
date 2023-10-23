//
//  ViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

final class GameViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var lifeIcon: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var backgroundImageMirrored: UIImageView!
    @IBOutlet var playerView: UIImageView!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var scoreBackground: UIView!
    @IBOutlet var buttonsBackground: UIView!
    @IBOutlet var gradientTintOverlay: UIView!
    
    @IBOutlet var closeGameButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet var playerXposition: NSLayoutConstraint!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lifeLeftLabel: UILabel!
    @IBOutlet var gameOverLabel: UILabel!
    
    //MARK: - Private properties
    private let storageManager = StorageManager.shared
    private let moveStep = Game.playerMoveStep
    
    
    private var obstaclesPassed: Int = .zero
    
    private var gameSpeed: Double {
        guard let speed = currentPlayer?.speed else { return 3 }
        return speed
    }
    
    private var obstacleSkin: String {
        guard let skin = currentPlayer?.obstacle else { return Skin.bolt.selection }
        
        return skin
    }
    
    private var playerLife = Game.playerLifeCount
    
    private var spawnTimer: Timer?
    private var scoreTimer: Timer?
    private var spawnCoordinates: [CGFloat]?
    
    //MARK: - Other properties
    var currentPlayer: User?
    
    override var prefersStatusBarHidden: Bool { true }
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlayerSkin()
        
        setVisualSettings()
        gradientTintOverlay.setGradientBackground()
        updateLifeCounter()
        
        spawnCoordinates = getSpawnCoordinates()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground()
        updateScore()
        
        spawnTimer = Timer.scheduledTimer(timeInterval: gameSpeed / Constant.three, target: self, selector: #selector(generateObstacles), userInfo: nil, repeats: true)
        
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
        
        animatePlayerIdle()
    }
    
    
    //MARK: - IBActions
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if playerView.center.x - moveStep > view.bounds.minX + moveStep / Constant.two {
            playerXposition.constant -= moveStep
            
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear)
            
            animator.addAnimations {
                self.playerView.frame = self.playerView.frame.offsetBy(dx: -self.moveStep, dy: .zero)
                self.playerView.transform = CGAffineTransform(scaleX: Constant.three, y: 0.1)
            }
            animator.addCompletion { _ in
                self.animatePlayerIdle()
            }
            animator.startAnimation()
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        if playerView.center.x + moveStep < view.bounds.maxX - moveStep / 2 {
            playerXposition.constant += moveStep
            
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear)
            animator.addAnimations {
                self.playerView.frame = self.playerView.frame.offsetBy(dx: self.moveStep, dy: .zero)
                self.playerView.transform = CGAffineTransform(scaleX: 3, y: 0.1)
            }
            animator.addCompletion { _ in
                self.animatePlayerIdle()
            }
            animator.startAnimation()
        }
    }
    
    //MARK: - Flow
    private func setVisualSettings() {
        buttonsBackground.backgroundColor = .black
        buttonsBackground.layer.opacity = 0.4
        buttonsBackground.layer.cornerRadius = 15
        buttonsBackground.layer.borderWidth = 3
        buttonsBackground.layer.borderColor = UIColor.systemGreen.cgColor
        
        lifeIcon.layer.shadowOpacity = 1
        lifeIcon.layer.shadowColor = UIColor.black.cgColor
        lifeIcon.layer.shadowRadius = 15
        
        scoreBackground.layer.opacity = buttonsBackground.layer.opacity
        scoreBackground.layer.cornerRadius = buttonsBackground.layer.cornerRadius
        scoreBackground.layer.borderWidth = buttonsBackground.layer.borderWidth
        scoreBackground.layer.borderColor = buttonsBackground.layer.borderColor
        
        playerView.tintColor = .systemGreen
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowColor = playerView.tintColor.cgColor
        playerView.layer.shadowRadius = 25
    }
    
    private func loadPlayerSkin() {
        guard let playerSkin = currentPlayer?.skin else { return }
        playerView.image = UIImage(systemName: playerSkin)
    }
    
    
    private func animateBackground() {
        UIView.animate(withDuration: gameSpeed,
                       delay: .zero,
                       options: [.repeat, .curveLinear],
                       animations: {
            self.backgroundImage.transform = CGAffineTransform(translationX: .zero, y: self.view.bounds.maxY)
            self.backgroundImageMirrored.transform = CGAffineTransform(translationX: .zero, y: self.view.bounds.maxY)
        })
    }
    
    private func getSpawnCoordinates() -> [CGFloat] {
        let obstacleCoordinates = [view.center.x, view.center.x - moveStep, view.center.x + moveStep]
        
        return obstacleCoordinates
    }
    
    private func lifeLeftCount() {
        if playerLife != .zero {
            playerLife -= 1 }
    }
    
    private func updateLifeCounter() {
        lifeLeftLabel.text = String(playerLife)
    }
    
    @objc private func updateScore() {
        scoreLabel.text = "\(Constant.score) \(obstaclesPassed)"
    }
    
    private func animatePlayerIdle() {
        UIView.animate(withDuration: 0.3,
                       delay: .zero,
                       options: [.repeat],
                       animations: {
            self.playerView.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            self.playerView.transform = CGAffineTransform(scaleX: 0.9, y: 1.1)
        })
    }
    
    private func animatePlayerDeath() {
        
        UIView.animate(withDuration: 0.6,
                       delay: .zero,
                       options: [.curveLinear],
                       animations: {
            self.playerView.transform = CGAffineTransform(scaleX: 15, y: 0.2)
            
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.8,
                           delay: .zero,
                           options: [.curveLinear],
                           animations: {
                self.playerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { _ in
                
                self.playerView.removeFromSuperview()
            })
        })
    }
    
    @objc private func generateObstacles() {
        guard let spawnCoordinates else { return }
        guard let randomX = spawnCoordinates.randomElement() else { return }
        
        let frameSide: CGFloat = Game.obstacleFrameSide
        
        let obstacle = UIImageView(frame: CGRect(x: randomX - frameSide / 2,
                                                  y: view.bounds.minY,
                                                  width: frameSide,
                                                  height: frameSide))
        obstacle.image = UIImage(systemName: obstacleSkin)
        obstacle.tintColor = .systemYellow
        obstacle.layer.shadowOpacity = 1
        obstacle.layer.shadowColor = obstacle.tintColor.cgColor
        obstacle.layer.shadowRadius = 3
        obstacle.alpha = 0.1
        gradientTintOverlay.addSubview(obstacle)
        
        
        let startAnimator = UIViewPropertyAnimator(duration: gameSpeed * 0.7, curve: .linear)
        let endAnimator = UIViewPropertyAnimator(duration: gameSpeed, curve: .linear)
        
        
        UIView.animate(withDuration: 3,
                       delay: .zero,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5.2,
                       options: [.repeat, .curveLinear],
                       animations: {
            
            obstacle.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            
            obstacle.alpha = 1
        })
        
        
        startAnimator.addAnimations {
            
            obstacle.frame = obstacle.frame.offsetBy(dx: .zero, dy: self.playerView.center.y)
            
        }
        
        endAnimator.addAnimations {
            obstacle.frame = obstacle.frame.offsetBy(dx: .zero, dy: self.view.bounds.maxY)
        }
        
        endAnimator.addCompletion { _ in
            
            self.updateScore()
            obstacle.removeFromSuperview()
            
        }
        
        startAnimator.addCompletion { _ in
            if obstacle.frame.intersects(self.playerView.frame) && self.playerLife != .zero {
                
                if self.playerLife < 2 {
                    obstacle.removeFromSuperview()
                    startAnimator.stopAnimation(true)
                    self.spawnTimer?.invalidate()
                    self.leftButton.isEnabled.toggle()
                    self.rightButton.isEnabled.toggle()
                    self.animatePlayerDeath()
                    self.backgroundImage.layer.removeAllAnimations()
                    self.backgroundImageMirrored.layer.removeAllAnimations()
                    
                    guard let player = self.currentPlayer else { return }
                    self.storageManager.update(player, newScore: Int64(self.obstaclesPassed))
                    self.showGameOverState()
                }
                self.lifeLeftCount()
                self.updateLifeCounter()
                obstacle.removeFromSuperview()
            } else if self.playerLife != .zero {
                self.configurateScoreMultiplayer() }
            
            endAnimator.startAnimation()
        }
        startAnimator.startAnimation()
    }
    
    
    private func configurateScoreMultiplayer() {
        switch currentPlayer?.speed {
        case Mode.hard.speed:
            obstaclesPassed += 2
        case Mode.extreme.speed:
            obstaclesPassed += 3
        default:
            obstaclesPassed += 1
        }
    }
    
    private func showGameOverState() {
        UIView.animate(withDuration: 0.6,
                       delay: .zero,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {
            self.gameOverLabel.isHidden = false
            self.gameOverLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.6,
                       delay: .zero,
                       options: [.curveLinear, .repeat, .autoreverse, .allowUserInteraction],
                       animations: {
            self.closeGameButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        
        
    }
                       
    
    
    
    
}
