//
//  TKNavigationController.m
//  Created by Devin Ross on 3/23/11.
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

#import "TKNavigationController.h"

#pragma mark -

@implementation TKNavigationItem
@synthesize customBackButtonItem = _customBackButtonItem;

- (void) dealloc{
	[_customBackButtonItem release],_customBackButtonItem=nil;
	[super dealloc];
}

@end

#pragma mark -
@implementation TKNavigationBar
@synthesize customBackgroundImage = _customBackgroundImage;

- (void) drawRect:(CGRect)rect{
	if(_customBackgroundImage!=nil)
		[_customBackgroundImage drawInRect:rect];
	else
		[super drawRect:rect];
	
}
- (void) setCustomBackgroundImage:(UIImage *)img{
	[_customBackgroundImage release];
	_customBackgroundImage = [img retain];
	[self setNeedsDisplay];
}
- (void) dealloc{
	[_customBackgroundImage release];
	[super dealloc];
}

@end

#pragma mark -
@implementation TKNavigationController
@synthesize customNavigationBar=_customNavigationBar;

- (void) dealloc{
	[_customNavigationBar release],_customNavigationBar=nil;
	[super dealloc];
}


- (BOOL) navigationBar:(UINavigationBar *)navBar shouldPushItem:(UINavigationItem *)item{
	if(navBar!=_customNavigationBar) return NO;
	return YES;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	UIViewController *current = [self topViewController];
	
	if([current.navigationItem isKindOfClass:[TKNavigationItem class]]){
		TKNavigationItem *navItem = (TKNavigationItem*)current.navigationItem;
		if(viewController.navigationItem.leftBarButtonItem==nil){
			navItem.customBackButtonItem.customView.backgroundColor = [UIColor clearColor];
			viewController.navigationItem.leftBarButtonItem = navItem.customBackButtonItem;

		}
	}
	
	[super pushViewController:viewController animated:animated];
	[self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];

}

- (UIViewController*) popViewControllerAnimated:(BOOL)animated{

	UIViewController *vc = [super popViewControllerAnimated:animated];
	[self.customNavigationBar popNavigationItemAnimated:animated];
	return vc;
}


- (TKNavigationBar *) customNavigationBar{
	if(_customNavigationBar==nil){
		_customNavigationBar = [[TKNavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
		_customNavigationBar.delegate = self;
		
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
		[_customNavigationBar pushNavigationItem:item animated:NO];
		[item release];
	}
	return _customNavigationBar;
}
- (UINavigationBar *) navigationBar{	
	return (self.customNavigationBar)?(self.customNavigationBar):([super navigationBar]);
}



@end
