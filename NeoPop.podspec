Pod::Spec.new do |s|
  s.name             = 'NeoPop'
  s.version          = '1.0.0'
  s.summary          = "NeoPop is CRED's inbuilt library for using Neopop components in your app."
  s.description      = "What really is NeoPop? NeoPop was created with one simple goal, to create the next generation of the next beautiful, more affirmative, design system. neopop stays true to everything that design at CRED stands for."
  s.homepage         = 'https://github.com/CRED-CLUB/neopop-ios'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE.md' }
  s.authors          = { 'CRED' => 'opensource@cred.club' }
  s.source           = { :git => 'https://github.com/CRED-CLUB/neopop-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version    = '5.5'
  s.source_files     = 'Sources/NeoPop/**/*.{swift, plist, podspec}'
  s.resources = "Sources/NeoPop/**/*.{xcassets}"
  s.module_name    = 'NeoPop'
end
