//
//  DataTests.m
//  Created by Devin Ross on 12/29/12.
//
/*
 
 tapku || https://github.com/devinross/tapkulibrary
 
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

#import "DataTests.h"


@interface SampleItem : NSObject

@property (nonatomic,strong) NSNumber *identifier;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) NSDate *updatedAt;

@end

@implementation SampleItem

+ (NSDictionary*) dataKeys{
	return @{
	@"identifier" : @"id",
	@"name" : @"name",
	@"createdAt" : @[@"created_at",@"yyyy-MM-dd'T'HH:mm:ss"],
	@"updatedAt" : @[@"updated_at",@"yyyy-MM-dd"]
	};
}

@end

@implementation DataTests

- (void) testDataImporting{
	
	NSDictionary *dict = @{
	@"id" : @8000,
	@"created_at" : @"2012-03-12T18:45:00",
	@"updated_at" : @"2012-03-12",
	@"name" : @"Bobby Sanderson"
	};
	
	
	SampleItem *item = [SampleItem createObject:dict];
	
	STAssertEqualObjects(dict[@"name"], item.name, @"%@ isn't equal to %@",dict[@"name"],item.name);
	STAssertEqualObjects(dict[@"id"], item.identifier, @"%@ isn't equal to %@",dict[@"id"],item.identifier);
	STAssertNotNil(item.createdAt, @"SampleItem createdAt should not be nil");
	STAssertNotNil(item.updatedAt, @"SampleItem updatedAt should not be nil");
	
	STAssertEqualObjects(NSStringFromClass([[NSDate date] class]), NSStringFromClass([item.createdAt class]),@"SampleItem createdAt property is not a NSDate class.");
	STAssertEqualObjects(NSStringFromClass([[NSDate date] class]), NSStringFromClass([item.updatedAt class]),@"SampleItem updatedAt property is not a NSDate class.");

}

@end
