//
//  Storyboard.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

enum Storyboard: String, StoryboardFileNameConvertible {
    
    case Main
    
    var filename: String { return self.rawValue }
    private var storyboard: UIStoryboard { return UIStoryboard(storyboard: self, bundle: .main) }
    
    func instantiate<T>(viewControllerType: T.Type) -> T where T: UIStoryboardIdentifiable {
        return storyboard.instantiate(viewControllerType: viewControllerType)
    }
    
    func instantiateInitialViewController() -> UIViewController? {
        return storyboard.instantiateInitialViewController()
    }
    
}

