source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def main_pods
    # Utils
    pod 'R.swift', '5.0.0.alpha.3' # static resources generator
    pod 'SwiftLint' # linter
    pod 'Sourcery' # generate code from stencil templates (for ContactsNetwork.framework)
    pod 'PromiseKit', '~> 6.0'
    pod 'Nuke' # image caching
    pod 'IQKeyboardManagerSwift'
    pod 'AWSS3', '2.7.4' # to upload an avatar image
    pod 'AWSCognito', '2.7.4' # credentials manager for upload to S3
end

def network_pods
    pod 'Moya', '~> 11.0' # network layer abstraction
end

target 'ContactsNetwork' do
  network_pods
end

target 'contacts-ios' do
  main_pods
  network_pods

  target 'ContactsTests' do
      pod 'SnapshotTesting', '~> 1.0'
  end

end
