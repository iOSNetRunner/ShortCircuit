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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.setGradientBackground()
        
        
        animateTitle()
        animateArrows()
        animateBackgroundGear()
        
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
        UIView.animate(withDuration: 5.0,
                       delay: 0,
                       
                       options: [.repeat, .curveLinear],
                       animations: {
            self.gearLogo.transform = self.gearLogo.transform.rotated(by: 2.09)
            
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
