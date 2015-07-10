Pod::Spec.new do |s|
  s.name         = "QTPaySDK_UI_All"
  s.version      = "1.0.6"
  s.summary      = "QTPay iOS SDK, contains all pay channels and UI interface."
  s.description  = <<-DESC
    QTPay iOS SDK, contains all pay channels and UI interface.
    * Enables every transaction.
                   DESC
  s.homepage     = "http://www.qfpay.com/"
  s.author       = { "Young Shook" => "lipengxing@qfpay.com" }
  s.license      = "COMMERCIAL"
  s.ios.platform = :ios, '6.0'
  s.source       = { :git => "https://github.com/QTPay/QTPaySDK-iOS.git", :tag => "#{s.version}_ui_all" }
  s.requires_arc = true
  s.ios.public_header_files  = "**/*.framework/**/*.h"
  s.vendored_libraries  = "**/*.a"
  s.vendored_frameworks = "**/*.framework"
  s.preserve_paths = "**/*.framework"
  s.resources    = "**/*.bundle"
  s.frameworks = 'Foundation', 'UIKit', 'CoreLocation', 'SystemConfiguration', 'MobileCoreServices'
  s.libraries = ["z", "c++", "sqlite3"]
  s.xcconfig  = { "OTHER_LDFLAGS" => "-lObjC",'LD_RUNPATH_SEARCH_PATHS' => '"$(SRCROOT)/**/*.framework"' }
end