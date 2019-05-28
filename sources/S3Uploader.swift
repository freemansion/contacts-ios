//
//  S3Uploader.swift
//  contacts-ios
//
//  Created by Stanislau Baranouski on 2/4/19.
//  Copyright © 2019 Stanislau Baranouski. All rights reserved.
//

import Foundation
import AWSS3
import AWSCognito
import UIKit
import PromiseKit

struct AWSConfig {
    let congitoPoolId: String
    let cognitoRegion: AWSRegionType
    let awsServiceRegion: AWSRegionType
    let S3Bucket: String

    static let `default` = AWSConfig(congitoPoolId: "your-aws-cognito-pool-id",
                                     cognitoRegion: .USWest2,
                                     awsServiceRegion: .APSoutheast1,
                                     S3Bucket: "contacts.app")
}

struct S3ImageUploader {
    enum S3UploadError: Error {
        case unknown
    }

    static func uploadImage(config: AWSConfig = .default,
                            image: UIImage,
                            usingeName imageName: String = NSUUID().uuidString) -> Promise<String> {
        // Configure AWS Cognito Credentials
        let identityPoolId = config.congitoPoolId
        let credentialsProvider: AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType: config.cognitoRegion, identityPoolId: identityPoolId)
        let configuration = AWSServiceConfiguration(region: config.awsServiceRegion, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let transferManager = AWSS3TransferManager.default()
        let path = NSTemporaryDirectory().stringByAppendingPathComponent("temp")
        let fileURL = URL(fileURLWithPath: path)

        let data = image.jpegData(compressionQuality: 0.5)!
        try? data.write(to: fileURL, options: .atomic)

        let uploadRequest: AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = config.S3Bucket
        uploadRequest.key = "\(imageName).jpg"
        uploadRequest.body = fileURL

        return Promise { resolver in
            let task = transferManager.upload(uploadRequest)
            task.continueWith { (task: AWSTask<AnyObject>) -> Any? in
                if let error = task.error {
                    resolver.reject(error)
                } else if let result = task.result as? AWSS3TransferManagerUploadOutput, let etag = result.eTag {
                    resolver.fulfill(etag)
                } else {
                    resolver.reject(S3UploadError.unknown)
                }
                return nil
            }
        }
    }
}
extension String {
    func stringByAppendingPathComponent(_ path: String) -> String {
        let st = self as NSString
        return st.appendingPathComponent(path)
    }
}
