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
    private var rootCoordinator = RootCoordinator()

    func instantiateWindow(makeKeyAndVisible: Bool = false) -> UIWindow {
        return rootCoordinator.instantiateWindow(makeKeyAndVisible: makeKeyAndVisible)
    }

}
