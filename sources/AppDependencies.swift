//
//  AppDependencies.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

protocol HasAppConfig {
    var appConfig: AppConfig { get }
}

protocol HasAppScreenManager {
    var appScreenManager: AppScreenManager { get }
}

protocol HasNetworkDataProvider {
    var dataProvider: NetworkDataProvider { get }
}

protocol HasKeyboardManager {
    var appKeyboardManager: IQKeyboardManager { get }
}

final class AppDependencies: HasAppConfig, HasAppScreenManager, HasNetworkDataProvider, HasKeyboardManager {

    let appConfig: AppConfig
    let appScreenManager: AppScreenManager
    let dataProvider: NetworkDataProvider
    let appKeyboardManager: IQKeyboardManager

    static let shared = AppDependencies()

    init(appConfig: AppConfig = .default,
         screenManager: AppScreenManager = .shared,
         dataProvider: NetworkDataProvider = NetworkDataProvider(),
         keyboardManager: IQKeyboardManager = .shared) {
        self.appConfig = appConfig
        self.appScreenManager = screenManager
        self.dataProvider = dataProvider
        self.appKeyboardManager = keyboardManager
    }
}
