//
//  AppConfig.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import ContactsNetwork

final class AppConfig {
    enum Constants {
        static var apiBaseURL: URL {
            #if DEBUG
            return URL(string: "https://young-atoll-90416.herokuapp.com")!
            #else
            return URL(string: "https://young-atoll-90416.herokuapp.com")!
            #endif
        }
    }

    static let `default` = AppConfig()
    private let screenManager = AppScreenManager.shared
    private let keyboardManager = IQKeyboardManager.shared

    func setup() {
        configureNetworkEnv()
        configureAppearance()
        setupKeyboardManager()
    }

    private func configureNetworkEnv() {
        let env = Environment.development(baseURL: Constants.apiBaseURL)
        NetworkApiService.setupEnvironment(usingEnv: env)
    }

    private func configureAppearance() {
        let themeColor = UIColor.Theme.greenishCyan
        let barButtonAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: themeColor,
                                                                  .font: R.font.sfuiTextRegular(size: 17)!]

        let navigationTitleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.Theme.greyishBrown,
                                                               .font: R.font.sfuiTextSemibold(size: 17)!]

        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
        UINavigationBar.appearance().tintColor = themeColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(barButtonAttributes, for: .normal)
    }

}

extension AppConfig {
    private func setupKeyboardManager() {
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.shouldPlayInputClicks = true
        keyboardManager.disabledToolbarClasses = [ContactViewController.self]
    }
}
