//
//  Alert.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

struct Alert {
    static func present(alert: UIAlertController) {
        var topViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        topViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func show(title: String? = nil, withMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alert: alertController)
    }
    
    static func show(title: String? = nil, withMessage message: String, otherButton buttonTitle: String, handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(action)
        present(alert: alertController)
    }
}
