//
//  NSDictionaryAdditions.m
//  Created by Devin Ross on 2/23/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "NSDictionary+TKCategory.h"


@implementation NSDictionary ( TKCategory )

- (NSString *) formatForHTTP {
	return [self formatForHTTPUsingEncoding:NSASCIIStringEncoding];
}
- (NSString *) formatForHTTPUsingEncoding:(NSStringEncoding)inEncoding{
	return [self formatForHTTPUsingEncoding:inEncoding ordering:nil];
}
- (NSString *) formatForHTTPUsingEncoding:(NSStringEncoding)inEncoding ordering:(NSArray *)inOrdering{
	
	NSMutableString *s = [NSMutableString stringWithCapacity:256];
	NSEnumerator *e = (nil == inOrdering) ? [self keyEnumerator] : [inOrdering objectEnumerator];
	id key;
	CFStringEncoding cfStrEnc = CFStringConvertNSStringEncodingToEncoding(inEncoding);
	
	while ((key = [e nextObject])){
		
        id keyObject = [self objectForKey: key];
		// conform with rfc 1738 3.3, also escape URL-like characters that might be in the parameters
		NSString *escapedKey = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) key, NULL, (CFStringRef) @";:@&=/+", cfStrEnc);
        if ([keyObject respondsToSelector: @selector(objectEnumerator)]){
            NSEnumerator *multipleValueEnum = [keyObject objectEnumerator];
            id aValue;
			
            while ((aValue = [multipleValueEnum nextObject])){
                NSString *escapedObject= (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes( NULL, (__bridge CFStringRef) [aValue description], NULL, (CFStringRef) @";:@&=/+", cfStrEnc);
                [s appendFormat:@"%@=%@&", escapedKey, escapedObject];
            }
			
        }else{
            NSString *escapedObject
            = (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(
                                                                   NULL, (__bridge CFStringRef) [keyObject description], NULL, (CFStringRef) @";:@&=/+", cfStrEnc);
            [s appendFormat:@"%@=%@&", escapedKey, escapedObject];
        }
	}
	if (![s isEqualToString:@""])
		[s deleteCharactersInRange:NSMakeRange([s length]-1, 1)];
	return s;       
}

@end