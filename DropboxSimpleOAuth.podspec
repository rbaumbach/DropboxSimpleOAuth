Pod::Spec.new do |s|
  s.name                  = 'DropboxSimpleOAuth'
  s.version               = '0.0.2'
  s.summary               = 'A quick and simple way to authenticate a Dropbox user in your iPhone or iPad app.'
  s.homepage              = 'https://github.com/rbaumbach/DropboxSimpleOAuth'
  s.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  s.author                = { 'Ryan Baumbach' => 'rbaumbach.github@gmail.com' }
  s.source                = { :git => 'https://github.com/rbaumbach/DropboxSimpleOAuth.git', :tag => s.version.to_s }
  s.requires_arc          = true
  s.platform              = :ios
  s.ios.deployment_target = '7.0'
  s.public_header_files   = 'DropboxSimpleOAuth/DropboxSimpleOAuth.h',   'DropboxSimpleOAuth/DropboxSimpleOAuthViewController.h',
                            'DropboxSimpleOAuth/DropboxLoginResponse.h'
  s.source_files          = 'DropboxSimpleOAuth/Source/*.{h,m}'
  s.resources             = 'DropboxSimpleOAuth/Source/*.xib'
  s.frameworks            = 'Foundation', 'UIKit'

  s.dependency 'MBProgressHUD', '~> 0.9'
  s.dependency 'SimpleOAuth2', '0.0.2'
end
