Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.4.63'
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

  s.subspec 'Core' do |core|
    core.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    core.ios.deployment_target = '11.0'
    core.source_files = 'SwifterUI/SwifterUI/UILibrary/*', 'SwifterUI/SwifterUI/UILibrary/**/*'
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

  s.subspec 'Firebase' do |firebase|
    firebase.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    firebase.ios.deployment_target = '11.0'
    firebase.source_files  = 'SwifterUI/SwifterUI/Firebase/*'
    firebase.dependency 'Firebase/Core'
    firebase.dependency 'Firebase/Auth'
    firebase.dependency 'Firebase/Firestore'
    firebase.dependency 'CodableFirebase'
    firebase.dependency 'SwifterUI/Core'
  end

  s.subspec 'Facebook' do |facebook|
    facebook.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    facebook.ios.deployment_target = '11.0'
    facebook.source_files  = 'SwifterUI/SwifterUI/Facebook/*'
    facebook.dependency 'FBSDKLoginKit'
    facebook.dependency 'SwifterUI/Core'
  end

end
