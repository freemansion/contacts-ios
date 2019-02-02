//
//  ImageLoader.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/2/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import Nuke

struct ImageLoader {
    static let `default` = ImageLoader()
    private init() {}

    @discardableResult
    func loadImage(url: URL?,
                   options: Nuke.ImageLoadingOptions = Nuke.ImageLoadingOptions.shared,
                   into view: Nuke.ImageDisplayingView,
                   progress: Nuke.ImageTask.ProgressHandler? = nil,
                   completion: Nuke.ImageTask.Completion? = nil) -> Nuke.ImageTask? {

        if let url = url {
            return Nuke.loadImage(with: url, options: options, into: view, progress: progress, completion: completion)
        } else {
            view.display(image: options.placeholder)
            return nil
        }
    }

}

extension Nuke.ImageLoadingOptions {
    static func imageLoadingOptions(placeholder: UIImage?) -> Nuke.ImageLoadingOptions {
        return Nuke.ImageLoadingOptions(placeholder: placeholder,
                                        transition: .fadeIn(duration: 0.33),
                                        failureImage: nil,
                                        failureImageTransition: .fadeIn(duration: 0.33),
                                        contentModes: .init(success: .scaleAspectFill,
                                                            failure: .center,
                                                            placeholder: .center))
    }
}
