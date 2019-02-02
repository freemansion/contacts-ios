//
//  AppScreenManager.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import UIKit

final class AppScreenManager {
    static let shared = AppScreenManager()

    private lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var initialScreens: [Storyboard] = [.Main]
    private var rootViewController: UIViewController?

    private init() {}

    func instantiateWindow(makeKeyAndVisible: Bool = false) -> UIWindow {
        if makeKeyAndVisible {
            rootViewController = instantiateRootViewController()
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
        return window
    }

    func instantiateRootViewController() -> UIViewController {
        let vc = Storyboard.Main.instantiate(viewControllerType: ContactsMainViewController.self)
        return UINavigationController(rootViewController: vc)
    }

}
