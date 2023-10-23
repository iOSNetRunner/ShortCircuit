//
//  Extension + UIViewController.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 22.10.2023.
//

import UIKit

extension UIViewController {
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
