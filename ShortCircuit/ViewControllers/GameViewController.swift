//
//  ViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var backgroundImageMirrored: UIImageView!
    @IBOutlet var buttonsBackground: UIView!
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundFor(uiView: buttonsBackground)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateBackground()
    }
    
    private func setBackgroundFor(uiView: UIView) {
        uiView.backgroundColor = .black
        uiView.layer.opacity = 0.3
        uiView.layer.cornerRadius = 15
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .curveLinear],
                       animations: {
            self.backgroundImage.frame = self.backgroundImage.frame.offsetBy(dx: 0, dy: self.backgroundImage.frame.height)
            self.backgroundImageMirrored.frame = self.backgroundImageMirrored.frame.offsetBy(dx: 0, dy: self.backgroundImageMirrored.frame.height)
            
        }, completion: nil)
    }
}

