platform :ios, '9.0'

target 'Mastering Language' do
  use_frameworks!

  # Pods for Mastering Language
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'GoogleSignIn'
  pod 'PromiseKit', '~> 4.4'
  pod 'PKHUD', '~> 4.0'
  pod 'Koloda', '~> 4.0'
  pod 'EasyTipView', '~> 1.0.2'
  pod 'AMWaveTransition'
  pod 'FSPagerView'
  
  target 'Mastering LanguageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Mastering LanguageUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
