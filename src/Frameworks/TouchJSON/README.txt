= Introduction =

TouchJSON is parser and generator for JSON implemented in Objective C.

It is based on Jonathan Wight's CocoaJSON code: http://toxicsoftware.com/cocoajson/


= How to use TouchJSON in your Cocoa or Cocoa Touch application. =

== Setup your project ==

Copy the source files within TouchJSON/Source to your project.
The easiest way is to open both projects in Xcode, then drag and drop.
Make sure to check "Copy items into destination groups folder (if needed)."

== To transform JSON to objects ==
Put #import "CJSONDeserializer.h" in your file.

Here is a code sample:

NSString *jsonString = @"yourJSONHere";
NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
NSError *error = nil;
NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];}


Note that if you don't care about the exact error, you can check that the dictionary returned by deserializeAsDictionary is nil.  In that case, use this code sample:

NSString *jsonString = @"yourJSONHere";
NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];


== To transform objects to JSON ==
Put #import "CJSONSerializer.h" in your file.

Here is a code sample:

NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"b" forKey:@"a"];
NSString *jsonString = [[CJSONSerializer serializer] serializeObject:dictionary];
