Pod::Spec.new do |s|
    s.name         = 'YZAuthID'
    s.version      = '2.1.0'
    s.summary      = 'TouchID/FaceID auth.'
    s.homepage     = 'https://github.com/micyo202/YZAuthID'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.authors      = {'Yanzheng' => 'micyo202@163.com'}
    s.platform     = :ios, '12.0'
    s.ios.deployment_target = '12.0'
    s.source       = {:git => 'https://github.com/micyo202/YZAuthID.git', :tag => s.version}
    s.source_files = 'YZAuthID/**/*.{h,m}'
    s.requires_arc = true
end
