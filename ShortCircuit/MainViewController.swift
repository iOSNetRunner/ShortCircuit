//
//  ViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var backgroundImageMirrored: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateBackground()
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .curveLinear],
                       animations: {
            self.backgroundImage.frame = self.backgroundImage.frame.offsetBy(dx: 0, dy: self.backgroundImage.frame.height)
            self.backgroundImageMirrored.frame = self.backgroundImageMirrored.frame.offsetBy(dx: 0, dy: self.backgroundImageMirrored.frame.height)
            
        }, completion: nil)
    }
}

