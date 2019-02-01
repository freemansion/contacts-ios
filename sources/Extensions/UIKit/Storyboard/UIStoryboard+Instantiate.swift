//
//  UIStoryboard+Instantiate.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/1/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol StoryboardFileNameConvertible {
    var filename: String { get }
}

extension UIStoryboard {
    convenience init(storyboard: StoryboardFileNameConvertible, bundle: Bundle) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    class func storyboard(storyboard: StoryboardFileNameConvertible, bundle: Bundle) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
}

extension UIStoryboard {
    func instantiate<T>(viewControllerType: T.Type) -> T where T: UIStoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }
        return viewController
    }
}
