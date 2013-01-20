//
//  NSObject+TKCategory.m
//  Created by Devin Ross on 12/29/12.
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

#import "NSObject+TKCategory.h"


#define VALID_OBJECT(_OBJ) _OBJ &&	(id)_OBJ != [NSNull null] && ((![_OBJ isKindOfClass:[NSString class]]) || [(NSString*)_OBJ length] > 0)


@implementation NSObject (TKCategory)


+ (NSDictionary*) dataKeys{
	return [NSDictionary dictionary];
}


+ (id) createObject:(NSDictionary*)data{
	return [[[self class] alloc] initWithDataDictionary:data];
}
- (id) initWithDataDictionary:(NSDictionary*)dictionary{
	if(!(self=[self init])) return nil;
	[self importDataWithDictionary:dictionary];
	return self;
}




- (void) importDataWithDictionary:(NSDictionary*)dictionary{
	
	
	NSDateFormatter *formatter = nil;
	NSDictionary *dataKeys = [[self class] dataKeys];
	
	for(NSString *dataKey in [dataKeys allKeys]){
		
		id value = [dataKeys objectForKey:dataKey];
		
		if([value isKindOfClass:[NSString class]]){
			
			id obj = [dictionary objectForKey:[dataKeys objectForKey:dataKey]];
			if(VALID_OBJECT(obj)) [self setValue:obj forKey:dataKey];
			
		}else if([value isKindOfClass:[NSArray class]]){
			
			NSString *format = [value lastObject];
			NSString *key = [value firstObject];
			
			if(VALID_OBJECT(format) && VALID_OBJECT(key)){
				if(!formatter) formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:format];
				NSDate *date = [formatter dateFromString:[dictionary objectForKey:key]];
				[self setValue:date forKey:dataKey];
			}
			
		}
		
	}
	
}

@end
