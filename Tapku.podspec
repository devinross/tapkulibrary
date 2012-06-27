Pod::Spec.new do |s|
  s.name			= 'Tapku Library'
  s.version  		= '2.1'
  s.license     	= { :type => 'MIT', :file => 'License.txt' }
  s.platform 		= :ios
  s.summary  		= 'tap + haiku = tapku, a well crafted open source iOS framework'
  s.homepage 		= 'http://tapku.com'
  s.author   		= { 'Devin Ross' => 'devin@devinsheaven.com' }
  s.source   		= { :git => 'https://github.com/devinross/tapkulibrary.git', :tag => '2.1' }
  s.description 	= 'TapkuLibrary is an iOS library built on Cocoa and UIKit intended for broad use in applications. If you\'re looking to see what the library can do, check out the demo project included. Some major components include coverflow, calendar grid, network requests and progress indicators.'
  s.source_files	= 'src/TapkuLibrary/**/*.{h,m}'
  s.requires_arc 	= true
  s.frameworks 		= 'QuartzCore', 'CoreGraphics', 'MapKit'
  s.xcconfig 		= { 'OTHER_LDFLAGS' => '-ObjC -all_load' }
end