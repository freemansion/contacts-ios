source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def main_pods
    # Utils
    pod 'R.swift', '~> 5.0.0.alpha.3'
    pod 'SwiftLint'
    pod 'Sourcery'
    pod 'PromiseKit', '~> 6.0'
    pod 'Nuke'
    pod 'IQKeyboardManagerSwift'
    pod 'AWSS3'
    pod 'AWSCognito'
end

def network_pods
    pod 'Moya', '~> 11.0'
end

target 'ContactsNetwork' do
  network_pods
end

target 'contacts-ios' do
  main_pods
  network_pods
end
