# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Matering Language' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Matering Language
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'

  target 'Matering LanguageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Matering LanguageUITests' do
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
