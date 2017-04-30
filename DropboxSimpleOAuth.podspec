Pod::Spec.new do |s|
  s.name                  = 'DropboxSimpleOAuth'
  s.version               = '0.2.0'
  s.summary               = 'A quick and simple way to authenticate a Dropbox user in your iPhone or iPad app.'
  s.homepage              = 'https://github.com/rbaumbach/DropboxSimpleOAuth'
  s.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  s.author                = { 'Ryan Baumbach' => 'github@ryan.codes' }
  s.source                = { :git => 'https://github.com/rbaumbach/DropboxSimpleOAuth.git', :tag => s.version.to_s }
  s.requires_arc          = true
  s.platform              = :ios
  s.ios.deployment_target = '8.0'
  s.public_header_files   = 'DropboxSimpleOAuth/Source/DropboxSimpleOAuth.h',   'DropboxSimpleOAuth/Source/DropboxSimpleOAuthViewController.h',
                            'DropboxSimpleOAuth/Source/DropboxLoginResponse.h'
  s.source_files          = 'DropboxSimpleOAuth/Source/*.{h,m}'
  s.resources             = 'DropboxSimpleOAuth/Source/*.xib'

  s.dependency 'SimpleOAuth2', '0.1.3'
  s.dependency 'MBProgressHUD', '>= 0.9'
end
