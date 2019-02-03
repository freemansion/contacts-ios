//
//  UIAlertController+Extensions.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func oneButtonAlert(alertTitle: String? = nil,
                               alertMessage: String,
                               buttonTitle: String,
                               buttonHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler)
        alert.addAction(action)
        return alert
    }

    static func twoButtonsAlert(alertTitle: String? = nil,
                                alertMessage: String,
                                button1Title: String,
                                button1Style: UIAlertAction.Style = .default,
                                button1Handler: ((UIAlertAction) -> Void)? = nil,
                                button2Title: String,
                                button2Style: UIAlertAction.Style = .default,
                                button2Handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action1 = UIAlertAction(title: button1Title, style: button1Style, handler: button1Handler)
        alert.addAction(action1)
        let action2 = UIAlertAction(title: button2Title, style: button2Style, handler: button2Handler)
        alert.addAction(action2)
        return alert
    }
}
