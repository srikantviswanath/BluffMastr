# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'BluffMastr' do
pod 'pop', '~> 1.0'
pod 'Firebase'
pod 'Instructions', '~> 0.5'
pod 'Firebase/Auth'
pod 'Firebase/Database'
end

target 'BluffMastrTests' do

end

target 'BluffMastrUITests' do

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = ‘2.3’
    end
  end
end