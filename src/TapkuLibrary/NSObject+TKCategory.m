//
//  NSObject+TKCategory.m
//  Created by Devin Ross on 12/29/12.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
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
	return @{};
}


+ (id) createObject:(NSDictionary*)data{
	return [[[self class] alloc] initWithDataDictionary:data];
}
- (id) initWithDataDictionary:(NSDictionary*)dictionary{
	
	if((id)dictionary == [NSNull null]) return nil;
	
	if(!(self=[self init])) return nil;
	[self importDataWithDictionary:dictionary];
	return self;
}
- (void) importDataWithDictionary:(NSDictionary*)dictionary{
	
	NSDateFormatter *formatter = nil;
	NSDictionary *dataKeys = [[self class] dataKeys];
	
	for(NSString *propertyKey in [dataKeys allKeys]){
		
		id value = dataKeys[propertyKey];
		
		if([value isKindOfClass:[NSString class]]){
			
			id obj = dictionary[dataKeys[propertyKey]];
			if(VALID_OBJECT(obj)) [self setValue:obj forKey:propertyKey];
			
		}else if([value isKindOfClass:[NSArray class]]){
			
			NSString *format = [value lastObject];
			NSString *key = [value firstObject];
			
			if(VALID_OBJECT(format) && VALID_OBJECT(key) && VALID_OBJECT(dictionary[key])){
				if(!formatter) formatter = [[NSDateFormatter alloc] init];
				[formatter setDateFormat:format];
				NSDate *date = [formatter dateFromString:dictionary[key]];
				[self setValue:date forKey:propertyKey];
			}
			
		}else if([value isKindOfClass:[NSDictionary class]]){
			
			NSDictionary *dataKeyDictionary = (NSDictionary*)value;
			Class class = NSClassFromString(dataKeyDictionary[@"class"]);
			id key = dataKeyDictionary[@"key"];
			Class structure = NSClassFromString(dataKeyDictionary[@"structure"]);
			if(structure == [NSArray class]){
				
				NSArray *array = dictionary[key];
				NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
				for(NSDictionary *subDictionary in array)
					[mutableArray addObject:[class createObject:subDictionary]];
				[self setValue:mutableArray.copy forKey:propertyKey];
				
			}else{
				id obj = [class createObject:dictionary[key]];
				[self setValue:obj forKeyPath:propertyKey];
			}
		}
	}
	
}


- (NSDictionary*) dataDictionary{
	
	NSDateFormatter *formatter = nil;
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];
	NSDictionary *dataKeys = [[self class] dataKeys];
	
	for(id propertyKey in [dataKeys allKeys]){
		
		id value = [self valueForKey:propertyKey];
		
		if(value && [value isKindOfClass:[NSDate class]]){
			NSArray *array = dataKeys[propertyKey];
			
			if(!formatter) formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = array.lastObject;
			NSString *date = [formatter stringFromDate:value];
			ret[array[0]] = date;
			
		}else if(value && [dataKeys[propertyKey] isKindOfClass:[NSDictionary class]]){
			
			NSDictionary *keyDict = dataKeys[propertyKey];
			
			if(NSClassFromString(keyDict[@"structure"]) == [NSArray class]){
				
				NSArray *propertyArray = value;
				
				if(!propertyArray) continue;
				
				NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:propertyArray.count];
				
				for(id obj in propertyArray){
					
					[dictArray addObject:[obj dataDictionary]];
				}
				
				
				ret[dataKeys[propertyKey][@"key"]] = dictArray.copy;
				
				
				
			}else{

				
				ret[dataKeys[propertyKey][@"key"]] = [value dataDictionary];

				
				
			}
			
			
		}else if(value)
			ret[dataKeys[propertyKey]] = value;
		
	}
	return ret;
	
}


#pragma mark Process JSON in Background
#if NS_BLOCKS_AVAILABLE
- (void) processJSON:(NSData*)data withCompletion:(TKJSONCompletionBlock)block{
	[self processJSON:data options:0 withCompletion:block];
}

- (void) processJSON:(NSData*)data options:(NSJSONReadingOptions)options withCompletion:(TKJSONCompletionBlock)block{
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
		
		NSError *error;
		id object = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
		dispatch_sync(dispatch_get_main_queue(), ^{
			block(object,error);
		});
	});
		
}
#endif

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback{
	
	[self processJSONDataInBackground:data
				 withCallbackSelector:callback
				   backgroundSelector:nil
						errorSelector:nil
					   readingOptions:0];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback readingOptions:(NSJSONReadingOptions)options{
	
	[self processJSONDataInBackground:data
				 withCallbackSelector:callback
				   backgroundSelector:nil
						errorSelector:nil
					   readingOptions:options];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor readingOptions:(NSJSONReadingOptions)options{
	
	[self processJSONDataInBackground:data
				 withCallbackSelector:callback
				   backgroundSelector:backgroundProcessor
						errorSelector:nil
					   readingOptions:options];
	
}

- (void) processJSONDataInBackground:(NSData *)data withCallbackSelector:(SEL)callback backgroundSelector:(SEL)backgroundProcessor errorSelector:(SEL)errroSelector{
	
	[self processJSONDataInBackground:data
				 withCallbackSelector:callback
				   backgroundSelector:backgroundProcessor
						errorSelector:errroSelector
					   readingOptions:0];
	
}


- (void) processJSONDataInBackground:(NSData *)data
				withCallbackSelector:(SEL)callback
				  backgroundSelector:(SEL)backgroundProcessor
					   errorSelector:(SEL)errroSelector
					  readingOptions:(NSJSONReadingOptions)options{
	
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	dict[@"data"] = data;
	dict[@"flags"] = @(options);
	

	if(callback) dict[@"callback"] = NSStringFromSelector(callback);
	if(backgroundProcessor) dict[@"backgroundProcessor"] = NSStringFromSelector(backgroundProcessor);
	if(errroSelector) dict[@"errroSelector"] = NSStringFromSelector(errroSelector);
	
	
	[self performSelectorInBackground:@selector(_processJSONData:) withObject:dict];
	
	
}


- (void) _processJSONData:(NSDictionary*)dict{
	@autoreleasepool {
		NSError *error = nil;
		
		NSData *data = dict[@"data"];
		NSUInteger options = [dict[@"flags"] unsignedIntValue];
		
		NSString *callback = dict[@"callback"];
		NSString *background = dict[@"backgroundProcessor"];
		NSString *eSelector = dict[@"errroSelector"];
		
		id object = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
		
		
		
		if(error && eSelector){
			[self performSelector:NSSelectorFromString(eSelector) withObject:error];
		}else if(!error){
			if(background) object = [self performSelector:NSSelectorFromString(background) withObject:object];
			[self performSelectorOnMainThread:NSSelectorFromString(callback) withObject:object waitUntilDone:NO];
		}
	}
}




@end
