# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'BloodPressure' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BloodPressure
  pod 'SwiftLint',      '~> 0.24.0'
  pod 'CareKit',        '~> 1.2.1'
  pod 'ResearchKit',    '~> 1.5.2'
  pod 'RxSwift',        '~> 4.0'
  pod 'RxCocoa',        '~> 4.0'

  target 'BloodPressureTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|

    # Disable code coverage for all Pods and Pods Project
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end

    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
end

