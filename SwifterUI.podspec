Pod::Spec.new do |s|
  s.name             = 'SwifterUI'
  s.version          = '0.9.2'
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
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.subspec 'Core' do |core|
    core.source_files = 'SwifterUI/SwifterUI/UILibrary/*', 'SwifterUI/SwifterUI/UILibrary/**/*'
    core.dependency 'DeepDiff'
  end

  s.subspec 'ChatKit' do |chatkit|
    chatkit.source_files  = 'SwifterUI/SwifterUI/ChatKit/**/*'
    chatkit.dependency 'SwifterUI/Core'
    chatkit.dependency 'Kingfisher'
  end

  s.subspec 'LoginKit' do |loginkit|
    loginkit.source_files  = 'SwifterUI/SwifterUI/LoginKit/**/*'
    loginkit.dependency 'SwifterUI/Core'
  end

end
