Pod::Spec.new do |s|
  s.name         = "APLisp"
  s.version      = "0.0.1"
  s.summary      = "APLisp - convention over configuration for blocks"

  s.description  = <<-DESC
                   APList - convention over configuration for blocks
                   * performBlock
                   * this
                   * params
                   * etc
                   DESC

  s.homepage     = "http://aplisp.com"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Andrei Puni" => "puni.andrei23@gmail.com" }
  
  s.platform     = :ios, '6.0'

  s.source       = { :git => "https://github.com/andrei512/APLisp.git", :tag => "0.0.1" }

  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  # s.public_header_files = 'Classes/**/*.h'


  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'


  s.requires_arc = true

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  
  s.dependency 'APUtils'
end
