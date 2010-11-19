//
//  CJSONDataSerializer.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/07/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CJSONDataSerializer.h"

#import "CSerializedJSONData.h"

static NSData *kNULL = NULL;
static NSData *kFalse = NULL;
static NSData *kTrue = NULL;

@implementation CJSONDataSerializer

+ (void)initialize
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

@synchronized(@"CJSONDataSerializer")
	{
	if (kNULL == NULL)
		kNULL = [[NSData alloc] initWithBytesNoCopy:"null" length:4 freeWhenDone:NO];
	if (kFalse == NULL)
		kFalse = [[NSData alloc] initWithBytesNoCopy:"false" length:5 freeWhenDone:NO];
	if (kTrue == NULL)
		kTrue = [[NSData alloc] initWithBytesNoCopy:"true" length:4 freeWhenDone:NO];
	}

[thePool release];
}

+ (id)serializer
{
return([[[self alloc] init] autorelease]);
}

- (NSData *)serializeObject:(id)inObject;
{
NSData *theResult = NULL;

if ([inObject isKindOfClass:[NSNull class]])
	{
	theResult = [self serializeNull:inObject];
	}
else if ([inObject isKindOfClass:[NSNumber class]])
	{
	theResult = [self serializeNumber:inObject];
	}
else if ([inObject isKindOfClass:[NSString class]])
	{
	theResult = [self serializeString:inObject];
	}
else if ([inObject isKindOfClass:[NSArray class]])
	{
	theResult = [self serializeArray:inObject];
	}
else if ([inObject isKindOfClass:[NSDictionary class]])
	{
	theResult = [self serializeDictionary:inObject];
	}
else if ([inObject isKindOfClass:[NSData class]])
	{
	NSString *theString = [[[NSString alloc] initWithData:inObject encoding:NSUTF8StringEncoding] autorelease];
	theResult = [self serializeString:theString];
	}
else if ([inObject isKindOfClass:[CSerializedJSONData class]])
	{
	theResult = [inObject data];
	}
else
	{
	[NSException raise:NSGenericException format:@"Cannot serialize data of type '%@'", NSStringFromClass([inObject class])];
	}
if (theResult == NULL)
	[NSException raise:NSGenericException format:@"Could not serialize object '%@'", inObject];
return(theResult);
}

- (NSData *)serializeNull:(NSNull *)inNull
{
#pragma unused (inNull)
return(kNULL);
}

- (NSData *)serializeNumber:(NSNumber *)inNumber
{
NSData *theResult = NULL;
switch (CFNumberGetType((CFNumberRef)inNumber))
	{
	case kCFNumberCharType:
		{
		int theValue = [inNumber intValue];
		if (theValue == 0)
			theResult = kFalse;
		else if (theValue == 1)
			theResult = kTrue;
		else
			theResult = [[inNumber stringValue] dataUsingEncoding:NSASCIIStringEncoding];
		}
		break;
	case kCFNumberFloat32Type:
	case kCFNumberFloat64Type:
	case kCFNumberFloatType:
	case kCFNumberDoubleType:
	case kCFNumberSInt8Type:
	case kCFNumberSInt16Type:
	case kCFNumberSInt32Type:
	case kCFNumberSInt64Type:
	case kCFNumberShortType:
	case kCFNumberIntType:
	case kCFNumberLongType:
	case kCFNumberLongLongType:
	case kCFNumberCFIndexType:
	default:
		theResult = [[inNumber stringValue] dataUsingEncoding:NSASCIIStringEncoding];
		break;
	}
return(theResult);
}

- (NSData *)serializeString:(NSString *)inString
{
NSMutableString *theMutableCopy = [[inString mutableCopy] autorelease];
[theMutableCopy replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"/" withString:@"\\/" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\b" withString:@"\\b" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\f" withString:@"\\f" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\r" withString:@"\\r" options:0 range:NSMakeRange(0, [theMutableCopy length])];
[theMutableCopy replaceOccurrencesOfString:@"\t" withString:@"\\t" options:0 range:NSMakeRange(0, [theMutableCopy length])];
/*
			case 'u':
				{
				theCharacter = 0;

				int theShift;
				for (theShift = 12; theShift >= 0; theShift -= 4)
					{
					int theDigit = HexToInt([self scanCharacter]);
					if (theDigit == -1)
						{
						[self setScanLocation:theScanLocation];
						return(NO);
						}
					theCharacter |= (theDigit << theShift);
					}
				}
*/
return([[NSString stringWithFormat:@"\"%@\"", theMutableCopy] dataUsingEncoding:NSUTF8StringEncoding]);
}

- (NSData *)serializeArray:(NSArray *)inArray
{
NSMutableData *theData = [NSMutableData data];

[theData appendBytes:"[" length:1];

NSEnumerator *theEnumerator = [inArray objectEnumerator];
id theValue = NULL;
NSUInteger i = 0;
while ((theValue = [theEnumerator nextObject]) != NULL)
	{
	[theData appendData:[self serializeObject:theValue]];
	if (++i < [inArray count])
		[theData appendBytes:"," length:1];
	}

[theData appendBytes:"]" length:1];

return(theData);
}

- (NSData *)serializeDictionary:(NSDictionary *)inDictionary
{
NSMutableData *theData = [NSMutableData data];

[theData appendBytes:"{" length:1];

NSArray *theKeys = [inDictionary allKeys];
NSEnumerator *theEnumerator = [theKeys objectEnumerator];
NSString *theKey = NULL;
while ((theKey = [theEnumerator nextObject]) != NULL)
	{
	id theValue = [inDictionary objectForKey:theKey];
	
	[theData appendData:[self serializeString:theKey]];
	[theData appendBytes:":" length:1];
	[theData appendData:[self serializeObject:theValue]];
	
	if (theKey != [theKeys lastObject])
		[theData appendData:[@"," dataUsingEncoding:NSASCIIStringEncoding]];
	}

[theData appendBytes:"}" length:1];

return(theData);
}

@end
