//
//  Extension + UIView.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 21.09.2023.
//

import UIKit

extension UIView {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.black.cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
