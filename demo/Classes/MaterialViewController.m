//
//  MaterialViewController.m
//  Demo
//
//  Created by Devin Ross on 12/22/14.
//
//

#import "MaterialViewController.h"

@interface MaterialViewController ()

@property (nonatomic,assign) BOOL flipper;

@end

@implementation MaterialViewController


- (void) loadView{
	[super loadView];
	self.colorView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.colorView.backgroundColor = [UIColor randomColor];
	[self.view addSubview:self.colorView];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self.view];
	
	
	[self.view materialTransitionWithSubview:self.colorView expandCircle:self.flipper atPoint:p duration:1 changes:^{
		self.colorView.backgroundColor = [UIColor randomColor];
	} completion:nil];
	
	
	self.flipper = !self.flipper;
	[self.view fireMaterialTouchDiskAtPoint:p];

	
}

@end
