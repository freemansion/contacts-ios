//
//  UINavigationController+Extensions.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

extension UINavigationController {

static private let defaultNavigationBar = UINavigationController().navigationBar

    func makeNavigationBar(with color: UIColor) {
        navigationBar.barTintColor = color
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    func makeNavigationBarTranslucent() {
        let navBar = UINavigationController.defaultNavigationBar
        navigationBar.barTintColor = navBar.barTintColor
        navigationBar.isTranslucent = true

        let backgroundImage = navBar.backgroundImage(for: .default)
        let shadowImage = navBar.shadowImage
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.shadowImage = shadowImage
    }

    func makeWhiteNavigationBar() {
        makeNavigationBar(with: .white)
    }
}
