//
//  TKSlideToUnlockView.h
//  TapkuLibrary
//
//  Created by Devin Ross on 5/21/13.
//
//

#import <UIKit/UIKit.h>

@interface TKSlideToUnlockView : UIControl

@property (nonatomic,strong) UIImageView *sliderView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIImageView *trackView;
@property (nonatomic,readonly) BOOL isUnlocked;

- (void) resetSlider:(BOOL)animated;

@end
