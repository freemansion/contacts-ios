//
//  GradientView.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

@IBDesignable open class GradientView: UIView {

    @IBInspectable open var startColor: UIColor = UIColor.white {
        didSet {
            self.updateView()
        }
    }

    @IBInspectable open var endColor: UIColor = UIColor.black {
        didSet {
            self.updateView()
        }
    }

    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            self.updateView()
        }
    }

    @IBInspectable open var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            self.updateView()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.updateView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateView()
    }

    fileprivate func updateView() {
        let colors = [self.startColor.cgColor, self.endColor.cgColor]
        self.gradientLayer.colors = colors
        self.gradientLayer.startPoint = self.startPoint
        self.gradientLayer.endPoint = self.endPoint

    }

    // MARK: - Helper
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    fileprivate var gradientLayer: CAGradientLayer {
        guard let layer =  self.layer as? CAGradientLayer else {
            assertionFailure()
            return CAGradientLayer(layer: self.layer)
        }
        return layer
    }
}
