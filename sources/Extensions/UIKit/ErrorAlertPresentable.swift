//
//  ErrorAlertPresentable.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ErrorAlertPresentable {
    func presentErrorAlert(title: String?, message: String, animated: Bool, handler: ((UIAlertAction) -> Void)?, completion: (() -> Void)?)
}

extension ErrorAlertPresentable where Self: UIViewController {
    func presentErrorAlert(title: String? = nil, message: String, animated: Bool = true, handler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController: UIAlertController = .oneButtonAlert(alertTitle: title, alertMessage: message, buttonTitle: R.string.localizable.error_alert_ok_button(), buttonHandler: handler)
        present(alertController, animated: animated, completion: completion)
    }
}

extension UIAlertController {
    static func oneButtonAlert(alertTitle: String? = nil, alertMessage: String, buttonTitle: String, buttonHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        alert.addAction(action)
        return alert
    }
}
