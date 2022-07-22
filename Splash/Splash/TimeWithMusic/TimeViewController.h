//
//  TimeViewController.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeViewController : UIViewController <SPTSessionManagerDelegate>
@property NSUInteger *pageIndex;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
