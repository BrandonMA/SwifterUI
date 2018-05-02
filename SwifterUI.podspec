Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.6.13'
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
  s.source_files = 'SwifterUI/SwifterUI/**/*', 'SwifterUI/SwifterUI/**/**/*'
  s.dependency 'PromiseKit', '~> 6.0'
  s.dependency 'DeepDiff'
  s.dependency 'PromiseKit', '~> 6.0'
  s.dependency 'DeepDiff'
  s.dependency 'CodableFirebase'
  s.dependency 'Firebase'
  # s.dependency 'Firebase/Core'
  # s.dependency 'Firebase/Auth'
  # s.dependency 'Firebase/Firestore'
  # s.dependency 'Firebase/Storage'

end
