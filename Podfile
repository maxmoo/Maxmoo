# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

target 'Maxmoo' do
  # Comment the next line if you don't want to use dynamic frameworks
  pod 'Alamofire', '~> 5.4.4'
  pod 'SnapKit'
  pod 'SwiftProtobuf'
  pod 'AliPlayerSDK_iOS', '5.4.7.1'
  pod 'AliPlayerSDK_iOS_ARTC', '5.4.7.1'
  pod 'RtsSDK', '2.2.0'
  pod 'DatabaseVisual'
  pod 'SQLite.swift', '~> 0.14.0'
  pod 'SDWebImage'

  #高德
  pod 'AMap3DMap-NO-IDFA'
  pod 'AMapSearch-NO-IDFA'
  pod 'AMapLocation-NO-IDFA'
  
  pod 'FLEX', :configurations => ['Debug']
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
