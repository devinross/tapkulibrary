//
//  TKGradientView.m
//  Created by Devin Ross on 9/21/11.
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

#import "TKGradientView.h"


@implementation TKGradientView


+ (Class)layerClass {
    return [CAGradientLayer class];
}
- (CAGradientLayer *) _gradientLayer{
    return (CAGradientLayer *)self.layer;
}



- (NSArray *) colors{
    NSArray *cgColors = [self _gradientLayer].colors;
    
	if (cgColors == nil) return nil;
    
    
    NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:[cgColors count]];
	
    for (id cgColor in cgColors) 
        [uiColors addObject:[UIColor colorWithCGColor:(__bridge CGColorRef)cgColor]];
    
    return [NSArray arrayWithArray:uiColors];
}
- (void)setColors:(NSArray *)newColors {
    NSMutableArray *newCGColors = nil;
	
    if (newColors != nil) {
        newCGColors = [NSMutableArray arrayWithCapacity:[newColors count]];
        for (id color in newColors) {

            if ([color isKindOfClass:[UIColor class]]) 
                [newCGColors addObject:(id)[color CGColor]];
             else
                [newCGColors addObject:color];
        }
    }
    
    [self _gradientLayer].colors = newCGColors;
}


- (NSArray *)locations {
    return [self _gradientLayer].locations;
}
- (void) setLocations:(NSArray *)newLocations {
    [self _gradientLayer].locations = newLocations;
}

- (CGPoint) startPoint{
    return [self _gradientLayer].startPoint;
}
- (void) setStartPoint:(CGPoint)newStartPoint {
    [self _gradientLayer].startPoint = newStartPoint;
}

- (CGPoint) endPoint{
    return [self _gradientLayer].endPoint;
}
- (void) setEndPoint:(CGPoint)newEndPoint {
    [self _gradientLayer].endPoint = newEndPoint;
}

- (NSString *) type{
    return [self _gradientLayer].type;
}
- (void) setType:(NSString *)newType {
    [self _gradientLayer].type = newType;
}



@end
