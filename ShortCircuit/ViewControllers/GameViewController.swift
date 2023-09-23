//
//  ViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var lifeIcon: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var backgroundImageMirrored: UIImageView!
    @IBOutlet var playerView: UIImageView!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var scoreBackground: UIView!
    @IBOutlet var buttonsBackground: UIView!
    @IBOutlet var gradientTintOverlay: UIView!
    
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet var playerXposition: NSLayoutConstraint!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lifeLeftLabel: UILabel!
    
    private let moveStep: CGFloat = 100
    
    private var obstaclesPassed = 0
    
    private var gameSpeed = 2.0
    private var playerLife = 3
    
    private var spawnTimer: Timer?
    private var scoreTimer: Timer?
    private var spawnCoordinates: [CGFloat]?
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setVisualSettings()
        gradientTintOverlay.setGradientBackground()
        updateLifeCounter()
        
        spawnCoordinates = getSpawnCoordinates()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground()
        updateScore()
        
        spawnTimer = Timer.scheduledTimer(timeInterval: gameSpeed / 3, target: self, selector: #selector(generateObstacles), userInfo: nil, repeats: true)
        
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
        
        animatePlayerIdle()
    }
    
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if playerView.center.x - moveStep > view.bounds.minX + moveStep / 2 {
            playerXposition.constant -= moveStep
            
            let animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear)
            
            animator.addAnimations {
                self.playerView.frame = self.playerView.frame.offsetBy(dx: -self.moveStep, dy: 0)
                self.playerView.transform = CGAffineTransform(scaleX: 3, y: 0.1)
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
                self.playerView.frame = self.playerView.frame.offsetBy(dx: self.moveStep, dy: 0)
                self.playerView.transform = CGAffineTransform(scaleX: 3, y: 0.1)
            }
            animator.addCompletion { _ in
                self.animatePlayerIdle()
            }
            animator.startAnimation()
        }
    }
    
    
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
        
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowColor = UIColor.systemYellow.cgColor
        playerView.layer.shadowRadius = 25
        
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: gameSpeed,
                       delay: 0,
                       options: [.repeat, .curveLinear],
                       animations: {
            self.backgroundImage.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.maxY)
            self.backgroundImageMirrored.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.maxY)
        })
    }
    
    private func getSpawnCoordinates() -> [CGFloat] {
        let obstacleCoordinates = [view.center.x, view.center.x - moveStep, view.center.x + moveStep]
        
        return obstacleCoordinates
    }
    
    private func lifeLeftCount() {
        if playerLife != 0 {
            playerLife -= 1 }
    }
    
    private func updateLifeCounter() {
        lifeLeftLabel.text = "\(playerLife)"
    }
    
    @objc private func updateScore() {
        scoreLabel.text = "SCORE: \(obstaclesPassed)"
    }
    
    private func animatePlayerIdle() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.repeat],
                       animations: {
            self.playerView.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            self.playerView.transform = CGAffineTransform(scaleX: 0.9, y: 1.1)
        })
    }
    
    private func animatePlayerDeath() {
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            self.playerView.transform = CGAffineTransform(scaleX: 25, y: 0.2)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.8,
                           delay: 0,
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
        
        let frameSide: CGFloat = 70
        
        let obstacle = UIImageView(frame: CGRect(x: randomX - frameSide / 2,
                                                  y: view.bounds.minY,
                                                  width: frameSide,
                                                  height: frameSide))
        obstacle.image = UIImage(systemName: "bolt.batteryblock.fill")
        obstacle.tintColor = .systemYellow
        obstacle.layer.shadowOpacity = 1
        obstacle.layer.shadowColor = obstacle.tintColor.cgColor
        obstacle.layer.shadowRadius = 3
        obstacle.alpha = 0.1
        gradientTintOverlay.addSubview(obstacle)
        
        
        let startAnimator = UIViewPropertyAnimator(duration: gameSpeed * 0.7, curve: .linear)
        let endAnimator = UIViewPropertyAnimator(duration: gameSpeed, curve: .linear)
        
        
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 5.2,
                       options: [.repeat, .curveLinear],
                       animations: {
            
            obstacle.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
            
            obstacle.alpha = 1
        })
        
        
        startAnimator.addAnimations {
            
            obstacle.frame = obstacle.frame.offsetBy(dx: 0, dy: self.playerView.center.y)
            
        }
        
        endAnimator.addAnimations {
            obstacle.frame = obstacle.frame.offsetBy(dx: 0, dy: self.view.bounds.maxY)
        }
        
        endAnimator.addCompletion { _ in
            
            self.updateScore()
            obstacle.removeFromSuperview()
            
        }
        
        startAnimator.addCompletion { _ in
            if obstacle.frame.intersects(self.playerView.frame) && self.playerLife != 0 {
                
                if self.playerLife < 2 {
                    obstacle.removeFromSuperview()
                    startAnimator.stopAnimation(true)
                    self.spawnTimer?.invalidate()
                    self.leftButton.isEnabled.toggle()
                    self.rightButton.isEnabled.toggle()
                    self.animatePlayerDeath()
                    self.view.subviews.forEach({$0.layer.removeAllAnimations()})
                    
                }
                self.lifeLeftCount()
                self.updateLifeCounter()
                obstacle.removeFromSuperview()
            } else if self.playerLife != 0 {
                self.obstaclesPassed += 1 }
            
            endAnimator.startAnimation()
        }
        startAnimator.startAnimation()
    }
}
