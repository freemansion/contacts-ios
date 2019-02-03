//
//  GenericCollectionViewCell.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/3/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import UIKit

protocol GenericReusableCellType {}
typealias GenericReusableCell = GenericReusableCellType

extension GenericReusableCellType where Self: UICollectionViewCell {

    func configure(as itemType: GenericCollectionViewCell.ItemType, separatorColor: UIColor = UIColor.Theme.separatorLine, spaceColor: UIColor = .clear, backgroundColor: UIColor? = nil, paddingLeft: CGFloat = 0) {
        switch itemType {

        case .separator:
            contentView.backgroundColor = backgroundColor ?? separatorColor
            if let cell = self as? GenericCollectionViewCell {
                cell.setSeparatorLinePaddingLeft(paddingLeft)
                cell.setSeparatorLineColor(separatorColor)
            }

        case .space:
            contentView.backgroundColor = spaceColor
            if let cell = self as? GenericCollectionViewCell {
                cell.setSeparatorLinePaddingLeft(0)
                cell.setSeparatorLineColor(spaceColor)
            }
        }

    }

    static func size(forWidth boundingWidth: CGFloat, itemType: GenericCollectionViewCell.ItemType, preferredHeight: CGFloat = 0) -> CGSize {
        switch itemType {
        case .separator:
            return CGSize(width: boundingWidth, height: GenericCollectionViewCell.separatorHeight)
        case .space:
            return CGSize(width: boundingWidth, height: preferredHeight)
        }
    }

}
