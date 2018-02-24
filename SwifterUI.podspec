Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.4.0'
  s.summary          = 'UI Library'
 
  s.description      = 'This is a UI Library to improve development process'
 
  s.homepage         = 'https://github.com/BrandonMA/SwifterUI'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { '<Brandon>' => '<maldonado.brandon177@gmail.com>' }
  s.source           = { :git => 'https://github.com/BrandonMA/SwifterUI.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'SwifterUI/SwifterUI/*', 'SwifterUI/SwifterUI/Extensions/*', 'SwifterUI/SwifterUI/Layout/*', 'SwifterUI/SwifterUI/SFGradient/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.subspec 'Animations' do |animations|
    animations.source_files = 'SwifterUI/SwifterUI/Animations/*'
  end

  s.subspec 'UILibrary' do |library|
    library.source_files = 'SwifterUI/SwifterUI/UILibrary/*', 'SwifterUI/SwifterUI/UILibrary/**/*'
  end
 
end
