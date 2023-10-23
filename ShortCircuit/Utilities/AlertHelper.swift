//
//  AlertHelper.swift
//  ShortCircuit
//
//  Created by Dmitrii Galatskii on 23.10.2023.
//
import UIKit

final class AlertHelper {
    static func showAlert(title: String?, message: String?, over viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Alert.ok, style: .default)
        
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true)
        
    }
}
