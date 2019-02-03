//
//  ConfirmationAlertPresentable.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol ConfirmationAlertPresentable {
    func presentConfirmationAlert(title: String?, message: String, animated: Bool, confirmationTitle: String, confirmationStyle: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?, completion: (() -> Void)?)
}

extension ConfirmationAlertPresentable where Self: UIViewController {
    func presentConfirmationAlert(title: String? = nil,
                                  message: String,
                                  animated: Bool = true,
                                  confirmationTitle: String,
                                  confirmationStyle: UIAlertAction.Style = .default,
                                  handler: ((UIAlertAction) -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
        let alertController: UIAlertController = .twoButtonsAlert(alertTitle: title,
                                                                  alertMessage: message,
                                                                  button1Title: confirmationTitle,
                                                                  button1Style: confirmationStyle,
                                                                  button1Handler: handler,
                                                                  button2Title: R.string.localizable.contacts_details_delete_alert_cancel_button(),
                                                                  button2Style: .cancel,
                                                                  button2Handler: nil)
        present(alertController, animated: animated, completion: completion)
    }
}
