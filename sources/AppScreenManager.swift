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
    
    lazy var window = UIWindow(frame: UIScreen.main.bounds)
    private lazy var initialScreens: [Storyboard] = [.Main]
    
    private init() {}
    
    func instantiateWindow(makeKeyAndVisible: Bool = false) -> UIWindow {
        if makeKeyAndVisible {
            window.rootViewController = instantiateRootViewController()
            window.makeKeyAndVisible()
        }
        return window
    }
    
    func instantiateRootViewController() -> UIViewController {
        return Storyboard.Main.instantiate(viewControllerType: ContactListViewController.self)
    }
    
}

