//
//  TKTimeGraph.m
//  Created by Devin Ross on 5/25/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
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

#import "TKTimeGraph.h"

#define stageHeight 240.0
#define stageTopMargin 30.0
#define pointDistance 50.0

#define kIndicatorWidth 80.0
#define kIndicatorHeight 43.0


@interface TKTimeGraph (PrivateMethods)

- (void) drawBackground:(CGContextRef)context;
- (void) drawBottomLine:(CGContextRef)context;
- (void) drawHorizontalLines:(CGContextRef)context;

- (void) getDelegateData;

- (float) valueToYCoordinate:(float)value;
- (float) yCoordinateToValue:(float)y;


@end
@implementation TKTimeGraph
@synthesize delegate, data;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		//NSLog(@"Init");
        // Initialization code
		
		
		title = [[UILabel alloc] initWithFrame:CGRectZero];
		title.backgroundColor = [UIColor clearColor];
		title.font = [UIFont boldSystemFontOfSize:16.0];
		title.textAlignment = UITextAlignmentCenter;
		[self addSubview:title];
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, stageTopMargin, self.frame.size.width, frame.size.height - 30)];
		scrollView.showsHorizontalScrollIndicator = YES;
		scrollView.backgroundColor = [UIColor clearColor];
		[self addSubview:scrollView];
		
		
		border = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask.png"]];
		[self addSubview:border];
		

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	//NSLog(@"drawRect");
	
	
    // Drawing code
	
	title.text = [delegate titleForTimeGraph:self];
	CGRect r = CGRectInset(rect,60, 8);
	r.size.height = 20;
	title.frame = r;
	
	if(data == nil){
		
		activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activity.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2,self.bounds.origin.y + self.bounds.size.height/2);
		[self addSubview:activity];
		[activity startAnimating];
		
		[NSThread detachNewThreadSelector:@selector(getDelegateData) toTarget:self withObject:nil];
		
		//[self getDelegateData];
	}else{
		CGContextRef context = UIGraphicsGetCurrentContext();
		[self drawBackground:context];
		[self drawBottomLine:context];
		[self drawHorizontalLines:context];
		
		float width = ([data count] + 1) * pointDistance;
		float height = scrollView.frame.size.height;
		
		scrollView.contentSize = CGSizeMake( width,height);
		
		pointsView = [[TKTimeGraphPointsView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
		[pointsView setData:data];
		pointsView.backgroundColor = [UIColor clearColor];
		[scrollView addSubview:pointsView];
		
	}
	
	
}


- (void) loadDelegateDataComplete{
	//NSLog(@"loadDelegateDataComplete");
	[activity removeFromSuperview];
	[activity release];
	[self setNeedsDisplay];
	float width = ([data count] + 1) * pointDistance;
	[scrollView setContentOffset:CGPointMake(width - 480,0) animated:NO];
}


- (void) noDelegateData{
	[activity removeFromSuperview];
	[activity release];
	UILabel *nodata = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100,40)];
	nodata.textAlignment = UITextAlignmentCenter;
	nodata.center = self.center;
	nodata.text = @"No Data";
	[self addSubview:nodata];
	[nodata release];

}
- (void) drawBackground:(CGContextRef)context{
	// GRAY BACKGROUND 
	CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, 300.0));
	
	CGContextSetRGBFillColor(context, 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.4);
	CGContextFillRect(context, CGRectMake(0, 0, 480.0, 270.0));
}
- (void) drawBottomLine:(CGContextRef)context{
	UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomline.png"]];
	[line setFrame:CGRectMake(2, 270, 475, 1)];
	[self addSubview:line];
	[line release];
}
- (void) drawHorizontalLines:(CGContextRef)context{
	
	// HORIZONTAL LINES
	for(int i=0; i < 7;i++){
		
		int yline = ((stageHeight/7) * i);
		int tim = [self yCoordinateToValue:yline];
		yline = [self valueToYCoordinate:tim];
		yline++;
		yline = stageHeight + stageTopMargin - yline;		
		
		
		
		UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontalline.png"]];
		[line setFrame:CGRectMake(0, yline, 480, 1)];
		[self addSubview:line];
		[self sendSubviewToBack:line];
		[line release];
		
		/*
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(3, yline-13, 55, 15)];
		[lab setFont:[UIFont systemFontOfSize:11.0]];
		[lab setTextColor:[UIColor grayColor]];
		[lab setBackgroundColor:[UIColor clearColor]];
		lab.text = [[delegate timeGraph:self yLabelForValue:tim] copy];
		[self addSubview:lab];
		[lab release];
		*/
		
		
		
		
		
		
	}
	
}

- (void) getDelegateData{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	int  numberOfPoints = [delegate numberofPointsOnTimeGraph:self];
	if(numberOfPoints < 1){
		[self performSelectorOnMainThread:@selector(noDelegateData) withObject:nil waitUntilDone:NO];
		[pool release];
		 return;
	}
	
	data = [[NSMutableArray alloc] initWithCapacity:numberOfPoints];
	NSNumber *n;
	int j = 0;
	while(YES){
		n = [delegate timeGraph:self  yValueForPoint:j];
		if(n != nil) break;
		j++;
	}
	highValue = [n floatValue];
	lowValue = [n floatValue];
	
	for(int i=0;i<numberOfPoints; i++){
		
		NSNumber *num = [delegate timeGraph:self  yValueForPoint:i];
		NSString *xLabel = [delegate timeGraph:self xLabelForPoint:i];
		NSMutableDictionary *point = [[NSMutableDictionary alloc] init];
		
		[point setObject:xLabel forKey:@"xLabel"];
		
		if(num != nil){
			[point setObject:num forKey:@"yValue"];
			float yValue = [num floatValue];
			[point setObject:[delegate timeGraph:self yLabelForValue:yValue] forKey:@"yLabel"];
			if(yValue > highValue) highValue = yValue;
			if(yValue < lowValue) lowValue = yValue;
		}
		[data addObject:point];
	}
	
	
	
	highValue = highValue + highValue * 0.05;
	lowValue = lowValue - lowValue * .05;
	
	for(int i=0;i<numberOfPoints;i++){
		NSMutableDictionary *d = [data objectAtIndex:i];
		
		if([d objectForKey:@"yValue"] != nil){
			float yCoor = [self valueToYCoordinate:[[d objectForKey:@"yValue"] floatValue]];
			yCoor = stageHeight - yCoor;
			[d setObject:[NSNumber numberWithFloat:yCoor] forKey:@"yCoordinate"];
		}
	}
	
	[self performSelectorOnMainThread:@selector(loadDelegateDataComplete) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (float) valueToYCoordinate:(float)value{
	float ret = stageHeight * ((value - lowValue) / (highValue - lowValue));
	//NSLog(@"%f * (%f-%f)/(%f-%f) = %f", stageHeight, value,lowValue,highValue,lowValue,ret );
	return  ret;
}
- (float) yCoordinateToValue:(float)y{
	float q = (((float)y)/stageHeight);
	q = q * (highValue - lowValue) + lowValue;
	return (float)q;
}
- (void) setTitle:(NSString*)str{
	title.text = [str copy];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"Touch scroll");
	
}

- (void)dealloc {
    [super dealloc];
}


@end


@implementation TKTimeGraphPointsView
@synthesize data;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		//NSLog(@"Init");
        // Initialization code
		


		
    }
    return self;
}
- (void) drawGraphFill:(CGContextRef) context{
	
	CGContextSetRGBFillColor(context, (230.0 / 255.0), (242.0/255.0), (250.0 / 255.0), 0.7);
	CGContextSetLineWidth(context, 0);
	
	//CGContextMoveToPoint(context, pointDistance, stageHeight);
	BOOL started = NO;
	
	int i=0;
	int j=0;
	for(; i < [data count]; i++){
		NSDictionary *d = [data objectAtIndex:i];
		if([d objectForKey:@"yCoordinate"] != nil){
			if(!started){
				CGContextMoveToPoint(context, (i+1) * pointDistance, stageHeight);
				started = YES;
			}
			//NSLog(@"%f",[[d objectForKey:@"yCoordinate"] floatValue]);
			CGContextAddLineToPoint(context,  (i+1) * pointDistance,[[[data objectAtIndex:i] objectForKey:@"yCoordinate"] floatValue]);
			j=i;
		}
	}
	
	CGContextAddLineToPoint(context, (j+1) * pointDistance, stageHeight);
	
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}
- (void) drawGraphLine:(CGContextRef) context{
	
	
	CGContextSetRGBStrokeColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 3);
	CGContextSetLineJoin(context, kCGLineJoinBevel);
	
	BOOL started = NO;
	
	CGContextMoveToPoint(context, pointDistance, [[[data objectAtIndex:0] objectForKey:@"yCoordinate"] floatValue]);
	
	for(int i = 0; i < [data count] ; i++){
		NSDictionary *d = [data objectAtIndex:i];
		
		float x = (i+1.0) * pointDistance;
		
		if([d objectForKey:@"yCoordinate"] != nil){
			
			float y = [[d objectForKey:@"yCoordinate"] floatValue];
			if(!started){
				CGContextMoveToPoint(context, x, [[[data objectAtIndex:i] objectForKey:@"yCoordinate"] floatValue]);
				started = YES;
			}else
				CGContextAddLineToPoint(context, x, y);
			
		}
		


		UIImageView *vert = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick.png"]];
		[vert setFrame:CGRectMake(x, stageHeight, 1, 8)];
		[self addSubview:vert];
		
		
		
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(x, stageHeight+4, 50, 15)];
		lab.text = [d objectForKey:@"xLabel"];
		[lab setFont:[UIFont boldSystemFontOfSize:10.0]];
		[lab setTextColor:[UIColor grayColor]];
		[lab setBackgroundColor:[UIColor clearColor]];
		[self addSubview:lab];
		
	}
	CGContextStrokePath(context);
}
- (void) drawPointCirles:(CGContextRef) context{
	
	//CGContextSetRGBStrokeColor(context,249.0/255.0, 249.0/255.0, 249.0/255.0, 1.0);
	CGContextSetRGBFillColor(context, 68.0/255.0, 152.0/255.0, 211.0/255.0, 1.0);
	CGContextSetLineWidth(context, 2);
	
	for(int i = 0; i < [data count] ; i++){
		
		
		NSDictionary *d = [data objectAtIndex:i];
		if([d objectForKey:@"yCoordinate"] != nil){
			int x = (i+1) * pointDistance, y = [[d objectForKey:@"yCoordinate"] floatValue];
			CGContextFillEllipseInRect(context, CGRectMake(x-4, y-4, 8.0, 8.0));
		}
		
		
		//CGContextStrokeEllipseInRect(context, CGRectMake(x-4, y-4, 8.0, 8.0) );
		
		//TouchPoint *v = [[TouchPoint alloc] initWithFrame:CGRectMake(x-15,y-15, 30.0, 30.0)];
		//[v setBoxId:i];
		//[v setDelegate:self];
		//[v setBackgroundColor:[UIColor clearColor]];
		//[self addSubview:v];
	}
	
}
- (void) drawRect:(CGRect)rect {
	//NSLog(@"drawRect");
	
	if([data count] < 2) return;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawGraphFill:context];
	[self drawGraphLine:context];
	[self drawPointCirles:context];

	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"Touch VIew");
	[super touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event];
	UITouch *t = [touches anyObject];
	CGPoint point = [t locationInView:self];
	//NSLog(@"Touched %f %f",point.x,point.y);
	
	
	
	if(indicator != nil){
		[indicator removeFromSuperview];
		[indicator release];
		indicator = nil;
	}
	
	int i = (point.x-(pointDistance/2)) / pointDistance;
	
	
	if(i >= [data count])
		i = [data count] - 1;
	else if(i < 0)
		i = 0;

	NSDictionary *d = [data objectAtIndex:i];
	
	if([d objectForKey:@"yValue"] == nil) return;
	
	float y = [[d objectForKey:@"yCoordinate"] floatValue];
	float x = i * pointDistance;
	
	//NSLog(@"%d: %f",i,x);
	NSString *str = [d objectForKey:@"yLabel"];
	
	if(y - kIndicatorHeight - 10 < 10)
		indicator = [[TKTimeGraphIndicator alloc] initWithFrame:CGRectMake((int)x + 10, (int)y + 6, kIndicatorWidth, kIndicatorHeight) 
														  title:str 
														 sideUp:NO];
	else 
		indicator = [[TKTimeGraphIndicator alloc] initWithFrame:CGRectMake((int)x + 10,(int)y - 45, kIndicatorWidth, kIndicatorHeight) 
													  title:str
													 sideUp:YES];
	[self addSubview:indicator];
	
	
	
	CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"opacity"];
	a.duration = 0.5;
	a.fromValue = [NSNumber numberWithFloat:0.0];
	a.toValue = [NSNumber numberWithFloat:1.0];
	[[indicator layer] addAnimation:a forKey:@"changeopacity"];
	indicator.layer.opacity = 1.0;

	
	
}

@end





@implementation TKTimeGraphIndicator

- (id)initWithFrame:(CGRect)frame title:(NSString*)str sideUp:(BOOL)up{
	[super initWithFrame:frame];
	if(up){
		background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup.png"]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, kIndicatorWidth - 6, 20)];
	}else{
		background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popdown.png"]];
		label = [[UILabel alloc] initWithFrame:CGRectMake(3, 14, kIndicatorWidth - 6, 20)];
	}
	
	
	
	label.text = str;
	label.font = [UIFont boldSystemFontOfSize:14.0];
	label.adjustsFontSizeToFitWidth = YES;
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	
	[self addSubview:background];
	[self addSubview:label];
	return self;
}
- (void)dealloc {
    [super dealloc];
	[background release];
	[label release];
}

@end