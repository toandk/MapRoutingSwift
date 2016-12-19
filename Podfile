platform :ios, '8.0'
use_frameworks!

def all_pods
  pod 'Box', '2.0'
  pod 'SDWebImage'
  pod 'ReactiveCocoa', '4.0.1'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'Alamofire', '~> 3.5'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  pod 'JSONModel'
#  pod 'PermissionScope', git: "git@github.com:nickoneill/PermissionScope.git"

end

target 'B4USwift' do
    all_pods
end

target "B4USwiftTests" do
    all_pods
    pod 'Quick', '~> 0.9.3'
    pod 'Nimble', '~> 4.1.0'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3' # or '3.0'
        end
    end
end
