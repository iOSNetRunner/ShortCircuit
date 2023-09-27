//
//  MainViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

final class MainViewController: UIViewController {

    
    @IBOutlet var arrowsImage: UIImageView!
    @IBOutlet var gearLogo: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var boltLogo: UIImageView!
    
    private var spawnTimer: Timer?
    
    var currentPlayer: User?
    
    
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground()
        
        
        if currentPlayer != nil {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
            startButton.setTitleColor(.gray, for: .disabled)
        }
        
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        spawnTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector( animateBackground), userInfo: nil, repeats: true)
        
        animateBackground()
        animateTitle()
        animateArrows()
        animateBackgroundGear()
        animateBolt()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        titleLabel.transform = CGAffineTransform.identity
        boltLogo.transform = CGAffineTransform.identity
    }
    
    
    
    
    
    @objc private func animateBackground() {
        let spawnPoint = CGFloat.random(in: view.bounds.minX...view.bounds.maxX)
        let frameSide = CGFloat.random(in: 10...50)
        
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
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
