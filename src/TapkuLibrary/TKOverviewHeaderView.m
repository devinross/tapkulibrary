//
//  InfoHeaderView.m
//  Created by Devin Ross on 7/13/09.
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

#import "TKOverviewHeaderView.h"
#import "TKGlobal.h"
#import "UIView+TKCategory.h"


@implementation TKOverviewHeaderView
@synthesize title,subtitle,indicator;


- (id) init{
	if (self = [super initWithFrame:CGRectMake(0, 0, 320, 70)]) {
        // Initialization code
		title = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 200, 23)];
		title.backgroundColor = [UIColor clearColor];
		title.font = [UIFont boldSystemFontOfSize:22.0];
		title.adjustsFontSizeToFitWidth = YES;
		[self addSubview:title];
		
		subtitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 34, 200, 22)];
		subtitle.backgroundColor = [UIColor clearColor];
		subtitle.font = [UIFont systemFontOfSize:16];
		subtitle.shadowColor = [UIColor whiteColor];
		subtitle.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1];
		subtitle.shadowOffset = CGSizeMake(0,1);
		[self addSubview:subtitle];
		
		
		indicator = [[TKOverviewIndicatorView alloc] initWithColor:TKOverviewIndicatorViewColorBlue];
		CGRect f = indicator.frame;
		f.origin.y = 18;
		f.origin.x = 175;
		indicator.frame = f;
		[self addSubview:indicator];
		
		self.backgroundColor = [UIColor clearColor];
		
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGFloat colors[] =
	{
		200 / 255.0, 207.0 / 255.0, 212.0 / 255.0, 1.00,
		169 / 255.0,  178.0 / 255.0, 185 / 255.0, 1.00
	};
	
	[UIView drawLinearGradientInRect:CGRectMake(0, 0, 320, 64) colors:colors];
	
	CGFloat colors2[] =
	{
		152/255.0, 156/255.0, 161/255.0, 0.6,
		152/255.0, 156/255.0, 161/255.0, 0.1
	};
	[UIView drawLinearGradientInRect:CGRectMake(0, 65, 320, 5) colors:colors2];
	
	CGFloat line[]={94 / 255.0,  103 / 255.0, 109 / 255.0, 1.00};
	[UIView drawLineInRect:CGRectMake(0, 64.5, 320, 0) colors:line];

}
- (void)dealloc {
	[title release];
	[subtitle release];
	[indicator release];
    [super dealloc];
}


@end
