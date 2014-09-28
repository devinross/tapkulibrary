//
//  TKSoundAlertController.h
//  Created by Devin Ross on 3/10/14.
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

@import Foundation;
@import AVFoundation;
@import AudioToolbox;

/** `TKSoundAlertController` plays simple user interface sounds. */
@interface TKSoundAlertController : NSObject <AVAudioPlayerDelegate>

/** Returns the singleton sound alert controller.
 @return The shared instance sound alert controller object.
 */
+ (TKSoundAlertController*) sharedInstance;

/** Plays a sound file immediately.
 @param soundName Plays a sound file with name 'insert-sound-name'.aif
 */
+ (void) playAIF:(NSString*)soundName;

/** Plays a sound file immediately.
 @param soundName Plays a sound file with name 'insert-sound-name'.aiff
 */
+ (void) playAIFF:(NSString*)soundName;

/** Plays a sound file immediately.
 @param soundName Plays a sound file with name 'insert-sound-name'.wav
 */
+ (void) playWAV:(NSString*)soundName;

/** Plays a sound file immediately.
 @param soundName Plays a sound file with name 'insert-sound-name'.caf
 */
+ (void) playCAF:(NSString*)soundName;


///----------------------------
/// @name Properties
///----------------------------
/** Flag to enable the play of the sound. If off, it will not play the sound. Default is off. */
@property (assign,nonatomic,getter = isOn) BOOL on;


- (void) playSoundName:(NSString*)soundName type:(NSString*)type;


@end
