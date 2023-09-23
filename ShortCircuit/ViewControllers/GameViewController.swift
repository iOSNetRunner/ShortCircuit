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
    
    
    @IBOutlet var playerXposition: NSLayoutConstraint!
    
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var lifeLeftLabel: UILabel!
    
    private let moveStep: CGFloat = 100
    
    
    private var obstaclesPassed = 0
    
    private var gameSpeed = 3.0
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
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        
        if playerView.center.x - moveStep > view.bounds.minX + moveStep / 2 {
            playerXposition.constant -= moveStep
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
            
            animator.addAnimations {
                self.playerView.frame = self.playerView.frame.offsetBy(dx: -self.moveStep, dy: 0)
            }
            
            
            animator.startAnimation()
        }
        
        
        
    }
    
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        if playerView.center.x + moveStep < view.bounds.maxX - moveStep / 2 {
            playerXposition.constant += moveStep
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 2,
                           initialSpringVelocity: 2,
                           options: .curveLinear,
                           animations: {
                self.playerView.frame = self.playerView.frame.offsetBy(dx: self.moveStep, dy: 0)})
        }
        
        
    }
    
    
    
    
    
    
    private func setVisualSettings() {
        buttonsBackground.backgroundColor = .black
        buttonsBackground.layer.opacity = 0.4
        buttonsBackground.layer.cornerRadius = 15
        buttonsBackground.layer.borderWidth = 3
        buttonsBackground.layer.borderColor = UIColor.systemGreen.cgColor
        
        lifeIcon.layer.shadowColor = UIColor.black.cgColor
        lifeIcon.layer.shadowRadius = 15
        
        scoreBackground.layer.opacity = buttonsBackground.layer.opacity
        scoreBackground.layer.cornerRadius = buttonsBackground.layer.cornerRadius
        scoreBackground.layer.borderWidth = buttonsBackground.layer.borderWidth
        scoreBackground.layer.borderColor = buttonsBackground.layer.borderColor
    }
    
    private func animateBackground() {
       
            UIView.animate(withDuration: gameSpeed,
                           delay: 0,
                           options: [.repeat, .curveLinear],
                           animations: {
                self.backgroundImage.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.maxY)
                self.backgroundImageMirrored.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.maxY)
            }
                
            
            )
        
        
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
    
    @objc private func generateObstacles() {
        guard let spawnCoordinates else { return }
        guard let randomX = spawnCoordinates.randomElement() else { return }
        
        let frameSide: CGFloat = 60
        
        let rectangle = UIImageView(frame: CGRect(x: randomX - frameSide / 2,
                                                  y: view.bounds.minY,
                                                  width: frameSide,
                                                  height: frameSide))
        rectangle.image = UIImage(systemName: "bolt.batteryblock.fill")
        rectangle.tintColor = .orange
        
        gradientTintOverlay.addSubview(rectangle)
        
        
        let startAnimator = UIViewPropertyAnimator(duration: gameSpeed * 0.7, curve: .linear)
        let endAnimator = UIViewPropertyAnimator(duration: gameSpeed, curve: .linear)
        
        
        startAnimator.addAnimations {
            
            
            rectangle.frame = rectangle.frame.offsetBy(dx: 0, dy: self.playerView.center.y)
        
            
        }
        
        endAnimator.addAnimations {
            rectangle.frame = rectangle.frame.offsetBy(dx: 0, dy: self.view.bounds.maxY)
        }
        
        endAnimator.addCompletion { _ in
            
            self.updateScore()
            rectangle.removeFromSuperview()
        }
        
        startAnimator.addCompletion { _ in
            if rectangle.frame.intersects(self.playerView.frame) {
            
                                        if self.playerLife < 2 {
                                            rectangle.removeFromSuperview()
                                            self.spawnTimer?.invalidate()
                                            startAnimator.stopAnimation(true)
                                            self.view.subviews.forEach({$0.layer.removeAllAnimations()})
                                            
                                        }



                                        self.lifeLeftCount()
                                        self.updateLifeCounter()
                                        rectangle.removeFromSuperview()
                
                
            
            } else { self.obstaclesPassed += 1 }
            
            
            endAnimator.startAnimation()
        }
        
        
        
        startAnimator.startAnimation()
        print("LIFE \(playerLife) |   SCORE \(obstaclesPassed)")
        
        
        
//        UIView.animate(withDuration: gameSpeed * 0.7,
//                           delay: 0,
//                       options: [ .curveLinear],
//                           animations: {
//            rectangle.center.y += self.playerView.center.y
//
//
//        }, completion: { _ in
//
//                    UIView.animate(withDuration: self.gameSpeed,
//                                   delay: 0,
//                                   options: [ .curveLinear],
//                                   animations: {
//                        if rectangle.frame.intersects(self.playerView.frame) {
//
//                            if self.playerLife < 2 {
//                                self.spawnTimer?.invalidate()
//                                self.view.subviews.forEach({$0.layer.removeAllAnimations()})
//                            }
//
//
//
//                            self.lifeLeftCount()
//                            self.updateLifeCounter()
//                            rectangle.removeFromSuperview()
//
//
//                        }
//                        rectangle.center.y += self.view.bounds.maxY}, completion: { _ in
//                            if rectangle.center.y > self.playerView.center.y - 500 {
//                                self.obstaclesPassed += 1
//                                self.updateScore()
//                                print(self.obstaclesPassed)
//                            }
//                            rectangle.removeFromSuperview()
//
//                        }
//
//
//
//                    )
//
//
//
//
//
//                    }
//                )
            
        
        
        
        
    }
    
    
}

