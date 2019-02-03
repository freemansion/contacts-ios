//
//  GenericCollectionViewCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

class GenericCollectionViewCell: UICollectionViewCell {

    static let separatorHeight: CGFloat = 0.5

    enum ItemType {
        case separator, space
    }

    @IBOutlet private weak var separatorLineView: UIView!
    @IBOutlet private weak var separatorLineLeadingConstraint: NSLayoutConstraint!

    func setSeparatorLineColor(_ color: UIColor) {
        separatorLineView.backgroundColor = color
    }

    func setSeparatorLinePaddingLeft(_ padding: CGFloat) {
        separatorLineLeadingConstraint.constant = padding
    }

}

extension GenericCollectionViewCell: GenericReusableCell {}
