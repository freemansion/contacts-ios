//
//  UIBarButtonItem+Extensions.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static var activityIndicatorButton: UIBarButtonItem = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = UIColor.Theme.greenishCyan
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let item = UIBarButtonItem(customView: activityIndicator)
        return item
    }()
}
