Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.6.21'
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
  s.source_files = 'SwifterUI/SwifterUI/**/*', 'SwifterUI/SwifterUI/**/**/*'

  s.dependency 'PromiseKit', '~> 6.0'
  s.dependency 'DeepDiff'
  s.dependency 'CodableFirebase'
  s.dependency 'Firebase/Core'
  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Firestore'
  s.dependency 'Firebase/Storage'

  s.pod_target_xcconfig = {
    "OTHER_LDFLAGS" => '$(inherited) -framework "FirebaseCore" -framework "FirebaseAuth" -framework "FirebaseFirestore" -framework "FirebaseStorage"',
    "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => 'YES',
    "FRAMEWORK_SEARCH_PATHS" => '$(inherited) "${PODS_ROOT}/FirebaseCore/Frameworks" "${PODS_ROOT}/FirebaseAuth/Frameworks" "${PODS_ROOT}/FirebaseFirestore/Frameworks" "${PODS_ROOT}/FirebaseStorage/Frameworks"',
    'SWIFT_VERSION' => '4.0'
  }

end
