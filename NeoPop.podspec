Pod::Spec.new do |s|
  s.name             = 'neopop-ios'
  s.version          = '1.0.0'
  s.summary          = 'NeoPop is CRED's inbuilt library for using Neopop components in your app.'
  s.homepage         = 'https://www.cred.club/'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Yadhu Manoharan' => 'yadhu.manoharan@cred.club',
                         'Somesh Karthik' => 'somesh.karthik@cred.club',
                         'Saranjith Krishnan' => 'saranjith.krishnan@cred.club',
                         'Harleen Singh' => 'harleen.singh@cred.club',
                         'Eldhose Lomy' => 'eldhose.lomy@cred.club',
                         'Utkarsh Dayal' => 'utkarsh.dayal@cred.club' }
  s.source           = { :git => 'https://github.com/CRED-CLUB/neopop-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.swift_version    = '5.5'
  s.source_files     = 'Sources/NeoPop/**/*'
end
