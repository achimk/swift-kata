# Uncomment this line to define a global platform for your project
platform :ios, '13.0'
# Uncomment this line if you're using Swift
use_frameworks!

workspace 'swift-kata'

def rxapp
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'Nimble', '~> 8'
end

def rxtests
  pod 'RxBlocking', '~> 5'
  pod 'RxTest', '~> 5'
end

target 'RxFun' do
    project 'RxFun/RxFun.xcodeproj'
    rxapp
end

target 'RxFunTests' do
    project 'RxFun/RxFun.xcodeproj'
    rxapp
    rxtests
end

# post_install do |installer|
#     installer.pods_project.targets.each do |target|
#         target.build_configurations.each do |config|
#             config.build_settings['ENABLE_BITCODE'] = "YES"
#             config.attributes.delete('EMBEDDED_CONTENT_CONTAINS_SWIFT')
#         end
#     end
# end
