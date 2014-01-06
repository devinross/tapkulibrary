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
#import "NSDate+TKCategory.h"


@interface SampleItem : NSObject

@property (nonatomic,strong) NSNumber *identifier;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSString *email;

@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) NSDate *updatedAt;
@property (nonatomic,strong) NSDate *deletedAt;
@property (nonatomic,strong) NSDate *finishedAt;

@end

@implementation SampleItem

+ (NSDictionary*) dataKeys{
	return @{
	@"identifier"	: @"id",
	@"name"			: @"name",
	@"createdAt"	: @[@"created_at",@"yyyy-MM-dd'T'HH:mm:ss"],
	@"updatedAt"	: @[@"updated_at",@"yyyy-MM-dd"],
	@"deletedAt"	: @[@"deleted_at"],
	@"finishedAt"	: @[@"finished_at",@"yyyy-MM-dd"]};
}

@end

@implementation DataTests

- (void) testDataImporting{
	
	NSDictionary *dict = @{
	@"id"			: @8000,
	@"created_at"	: @"2012-03-12T18:45:00",
	@"updated_at"	: @"2013-04-15",
	@"name"			: @"Bobby Sanderson",
	@"position"		: [NSNull null],
	@"phone"		: @"1-800-123-4567",
	@"deletedAt"	: @"2012-03-12",
	@"finishedAt"	: [NSNull null]

	};
	
	SampleItem *item = [SampleItem createObject:dict];
	
	XCTAssertEqualObjects(dict[@"name"], item.name, @"%@ isn't equal to %@",dict[@"name"],item.name);
	XCTAssertEqualObjects(dict[@"id"], item.identifier, @"%@ isn't equal to %@",dict[@"id"],item.identifier);
	XCTAssertNotNil(item.createdAt, @"SampleItem createdAt should not be nil");
	XCTAssertNotNil(item.updatedAt, @"SampleItem updatedAt should not be nil");
	
	
	NSDateComponents *components = [item.createdAt dateComponentsWithTimeZone:[NSTimeZone defaultTimeZone]];
	XCTAssertTrue(components.day == 12 && components.month == 3 && components.year == 2012 && components.hour == 18, @"SampleItem createdAt date property didn't match up with input 2012-03-12 != %ld-%ld-%ld",(long)components.year,(long)components.month,(long)components.day);
	
	
	components = [item.updatedAt dateComponentsWithTimeZone:[NSTimeZone defaultTimeZone]];
	XCTAssertTrue(components.day == 15 && components.month == 4 && components.year == 2013, @"SampleItem createdAt date property didn't match up with input 2013-04-15 != %ld-%ld-%ld",(long)components.year,(long)components.month,(long)components.day);
	
	
	XCTAssertNil(item.position, @"Finished at property is not nil");
	XCTAssertNil(item.finishedAt, @"Finished at property is not nil");
	XCTAssertNil(item.deletedAt, @"Finished at property is not nil");

	
	XCTAssertTrue([item.createdAt isKindOfClass:[NSDate class]], @"SampleItem 'createdAt' property is not a NSDate class.");
	XCTAssertTrue([item.updatedAt isKindOfClass:[NSDate class]], @"SampleItem 'updatedAt' property is not a NSDate class.");



	

}

- (void) testNoData{
	SampleItem *item;

	item = [SampleItem createObject:(id)[NSNull null]];
	XCTAssertNil(item, @"Item is nil");
	
	item = [SampleItem createObject:nil];
	XCTAssertNotNil(item, @"Item is nil");
}

@end
