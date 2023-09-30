//
//  Extension + UIImage.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 30.09.2023.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage? {
        if self.imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
