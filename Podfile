# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'SuperMessenger' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SuperMessenger

  target 'SuperMessengerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SuperMessengerUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  #pod 'SVProgressHUD'
  #pod 'Firebase/Core'
  #pod 'Firebase/Auth'
  #pod 'Firebase/Database'
#pod 'Firebase/Storage'
#pod 'FirebaseUI'
#pod 'Toast-Swift', '~> 4.0.0'
#pod 'SDWebImage', '~> 4.0'
#pod 'KILabel', '1.0.0'
#pod 'CarbonKit'

pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
#pod 'ChameleonFramework'
pod 'FirebaseUI'
pod 'Firebase/Core'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
