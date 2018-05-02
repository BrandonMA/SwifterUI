Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.6.10'
  s.summary          = 'UI Library'
 
  s.description      = 'This is a UI Library to improve development process'
 
  s.homepage         = 'https://github.com/BrandonMA/SwifterUI'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { '<Brandon>' => '<maldonado.brandon177@gmail.com>' }
  s.source           = {
                            :git => 'https://github.com/BrandonMA/SwifterUI.git',
                            :tag => s.version.to_s,
                            :submodules => true
  }

  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.static_framework = true

  s.subspec 'Core' do |core|
    core.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    core.ios.deployment_target = '11.0'
    core.source_files = 'SwifterUI/SwifterUI/UILibrary/*', 'SwifterUI/SwifterUI/UILibrary/**/*'
    core.dependency 'PromiseKit', '~> 6.0'
    core.dependency 'DeepDiff'
  end

  s.subspec 'ChatKit' do |chatkit|
    chatkit.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    chatkit.ios.deployment_target = '11.0'
    chatkit.source_files  = 'SwifterUI/SwifterUI/ChatKit/*'
    chatkit.dependency 'SwifterUI/Core'
  end

  s.subspec 'LoginKit' do |loginkit|
    loginkit.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    loginkit.ios.deployment_target = '11.0'
    loginkit.source_files  = 'SwifterUI/SwifterUI/LoginKit/**/*'
    loginkit.dependency 'SwifterUI/Core'
  end

  s.subspec 'FirebaseKit' do |firebaseKit|
    firebaseKit.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    firebaseKit.ios.deployment_target = '11.0'
    firebaseKit.source_files  = 'SwifterUI/SwifterUI/FirebaseKit/**/*'
    firebaseKit.dependency 'SwifterUI/Core'
    firebaseKit.dependency 'CodableFirebase'
    firebaseKit.dependency 'Firebase'
    firebaseKit.dependency 'Firebase/Core'
    firebaseKit.dependency 'Firebase/Auth'
    firebaseKit.dependency 'Firebase/Firestore'
    firebaseKit.dependency 'Firebase/Storage'

    firebaseKit.pod_target_xcconfig = {
      'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/Firebase $(PODS_ROOT)/FirebaseCore/Frameworks $(PODS_ROOT)/FirebaseRemoteConfig/Frameworks $(PODS_ROOT)/FirebaseInstanceID/Frameworks $(PODS_ROOT)/FirebaseAnalytics/Frameworks $(PODS_ROOT)/FirebaseABTesting/Frameworks'
    }

    firebaseKit.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '$(inherited) -ObjC'
    }
  end

end
