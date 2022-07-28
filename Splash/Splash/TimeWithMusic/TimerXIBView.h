//
//  TimerXIBView.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/25/22.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerXIBView : UIView
- (void) updateTime;
- (void) updateFontSize:(int)size;
@property (weak) UIViewController *root;
@end

NS_ASSUME_NONNULL_END
