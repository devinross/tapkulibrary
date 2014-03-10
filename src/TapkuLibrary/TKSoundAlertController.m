//
//  TKSoundAlertController.m
//  Created by Devin Ross on 12/17/13.
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

#import "TKSoundAlertController.h"

@interface TKSoundAlertController ()

@property (nonatomic,strong) NSMutableDictionary *sounds;

@end

@implementation TKSoundAlertController


+ (TKSoundAlertController*)sharedInstance {
	static TKSoundAlertController *instance = nil;
	if (!instance) {
		instance = [[TKSoundAlertController alloc] init];
	}
	return instance;
}
- (id) init{
	if(!(self=[super init])) return nil;
	self.sounds = [[NSMutableDictionary alloc] initWithCapacity:10];
	return self;
}
+ (void) playAIF:(NSString*)soundName {
	[[TKSoundAlertController sharedInstance] playSoundName:soundName type:@"aif"];
}
+ (void) playAIFF:(NSString*)soundName {
	[[TKSoundAlertController sharedInstance] playSoundName:soundName type:@"aiff"];
}
+ (void) playWAV:(NSString*)soundName {
	[[TKSoundAlertController sharedInstance] playSoundName:soundName type:@"wav"];
}
- (void) playSoundName:(NSString*)soundName type:(NSString*)type{
	if (!self.on)
		return;
	
	NSNumber *soundIDHolder = [self.sounds objectForKey:soundName];
	if (soundIDHolder) {
		SystemSoundID soundID = (SystemSoundID) [soundIDHolder unsignedLongValue];
		AudioServicesPlaySystemSound(soundID);
	} else {
		NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:type];
		if (path) {
			NSURL *url = [NSURL fileURLWithPath:path];
			SystemSoundID soundID = 0;
			if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID) == noErr) {
				[self.sounds setObject:[NSNumber numberWithUnsignedLong:soundID] forKey:soundName];
				AudioServicesPlaySystemSound(soundID);
			}
		}
	}
}

@end
