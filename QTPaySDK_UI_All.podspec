Pod::Spec.new do |s|
  s.name         = "QTPaySDK_UI_All"
  s.version      = "1.0.0"
  s.summary      = "QTPay iOS SDK, contains all pay channels and UI interface."
  s.description  = <<-DESC
                   * Enables every transaction.
                   DESC
  s.homepage     = "https://www.qfpay.com"
  s.author       = { "Young Shook" => "lipengxing@qfpay.com" }
  s.license      = "COMMERCIAL"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/QTPay/QTPaySDK-iOS.git", :tag => "#{s.version}_ui_all" }
  s.public_header_files     = "QTPaySDK.framework/Headers/*"
  s.vendored_libraries      = "PayChannels/**/*.a"
  s.vendored_frameworks = "PayChannels/**/*.framework", "QTPaySDK.framework"
  s.frameworks   = 'UIKit", 'Foundation'
  s.libraries = 'z', 'c++', 'sqlite3'
  s.xcconfig  = { "OTHER_LDFLAGS" => "-lObjC" }
end