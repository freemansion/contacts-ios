//
//  UIStoryboardIdentifiable.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol UIStoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIStoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
