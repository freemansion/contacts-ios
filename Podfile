source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def main_pods
    # Metacode
    pod 'R.swift', '~> 5.0.0.alpha.3'
    pod 'Sourcery'
end

def network_pods
    pod 'Moya', '~> 11.0'
end

# target 'ContactsNetwork' do
#   network_pods
# end

target 'contacts-ios' do
  main_pods
  network_pods
end
