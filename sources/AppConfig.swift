//
//  AppConfig.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import UIKit

final class AppConfig {
    static let `default` = AppConfig()
    private let screenManager = AppScreenManager.shared

    func setup() {
        configureAppearance()
    }

    private func configureAppearance() {
        let themeColor = UIColor.Theme.greenishCyan
        let barButtonAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: themeColor,
                                                                  .font: R.font.sfuiTextRegular(size: 17)!]

        let navigationTitleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.Theme.darkGray,
                                                               .font: R.font.sfuiTextSemibold(size: 17)!]

        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
        UINavigationBar.appearance().tintColor = themeColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(barButtonAttributes, for: .normal)
    }

}

