//
//  TimeViewController.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeViewController : UIViewController
+ (NSString*) formatTimeString:(int)secs;
+ (int) getRemainingSec: (int)secs;
+ (int) convertSecsToMin:(int)secs;
@end

NS_ASSUME_NONNULL_END
