//
//  UIView+Extensions.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableImageView: UIImageView {}

@IBDesignable
class DesignableView: UIView {}

@IBDesignable
class DesignableButton: UIButton {}

@IBDesignable
class DesignableLabel: UILabel {}

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
            setNeedsLayout()
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsLayout()
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
            setNeedsLayout()
        }
    }
}
