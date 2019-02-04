//
//  String+Extensions.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/4/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation

extension String {
    var notEmpty: Bool {
        return !byRemovingEmptySpace.isEmpty
    }

    var byRemovingEmptySpace: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
