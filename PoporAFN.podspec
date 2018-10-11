#
# Be sure to run `pod lib lint PoporAFN.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PoporAFN'
    s.version          = '0.0.5'
    s.summary          = 'combine afn, support net monitor;包装了AFN方法,支持网络监测功能(通过PoporNetRecord控制).'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    
    s.homepage         = 'https://github.com/popor/PoporAFN'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'popor' => '908891024@qq.com' }
    s.source           = { :git => 'https://github.com/popor/PoporAFN.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target  = '10.10' # minimum SDK with autolayout
    s.tvos.deployment_target = '9.0' # minimum SDK with autolayout
    
    s.source_files = 'PoporAFN/Classes/*.{h,m}'
    
    s.dependency 'AFNetworking'
    s.dependency 'PoporFoundation/PrefixCore'
    
    s.ios.dependency 'PoporNetRecord'
    
    #s.dependency 'PoporNetRecord'
    
    
end
