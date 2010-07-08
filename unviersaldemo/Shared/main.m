//
//  main.m
//  unviersaldemo
//
//  Created by Devin Ross on 7/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString *del = [[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPad ? @"AppDelegate_iPad" : @"AppDelegate_iPhone";
    int retVal = UIApplicationMain(argc, argv, nil, del);
    [pool release];
    return retVal;
}
