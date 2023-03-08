use_frameworks!
platform = :ios, '13.0'
target 'WeatherApp' do 
    pod 'SnapKit'
    pod 'RxCocoa'
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

