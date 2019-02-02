//
//  RootCoordinator.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

struct RootCoordinator {
    private lazy var rootViewController: UIViewController = {
        return ContactsMainViewController.makeInstance()
    }()

    private lazy var rootNavigationController: UIViewController = {
        return UINavigationController(rootViewController: rootViewController)
    }()

    private(set) var window: UIWindow?

    mutating func instantiateWindow(makeKeyAndVisible: Bool) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootNavigationController
        if makeKeyAndVisible {
            window.makeKeyAndVisible()
        }
        self.window = window
        return window
    }
}
