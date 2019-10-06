# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def client
  pod 'SDWebImage', '~> 5.0'
  pod 'PinLayout', '~> 1.8.11'
  pod 'Swinject', '~> 2.7.1'
end

def common
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
end

def test_framework 
  pod 'RxTest', '~> 5.0'
  pod 'RxBlocking', '~> 5.0'
  pod 'Quick'
  pod 'Nimble'
end

target 'lakes' do
  client
  common
end

target 'lakesTests' do
  common
  test_framework
end