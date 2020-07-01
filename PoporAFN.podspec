#
# Be sure to run `pod lib lint PoporAFN.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name     = 'PoporAFN'
    s.version  = '1.06'
    s.summary  = 'combine afn, support net monitor;包装了AFN方法,支持网络监测功能(通过PoporNetRecord控制).'

    s.homepage = 'https://github.com/popor/PoporAFN'
    s.license  = { :type => 'MIT', :file => 'LICENSE' }
    s.author   = { 'popor' => '908891024@qq.com' }
    s.source   = { :git => 'https://github.com/popor/PoporAFN.git', :tag => s.version.to_s }
    
    s.ios.deployment_target  = '9.0'
    s.osx.deployment_target  = '10.10' # minimum SDK with autolayout
    s.tvos.deployment_target = '9.0' # minimum SDK with autolayout
    
    s.source_files = 'PoporAFN/Classes/*.{h,m}'
    
    s.dependency 'AFNetworking'
end
