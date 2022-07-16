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
+ (NSString*) formatTimeString:(int)secs;
+ (int) getRemainingSec: (int)secs;
+ (int) convertSecsToMin:(int)secs;

+ (void) yo;

@property SPTConfiguration *configuration;
@property SPTSessionManager *sessionManager;
@property SPTAppRemote *appRemote;
@property (nonatomic) NSString *responseCode;


//@property (strong, nonatomic) SPTAppRemoteAccessTokenKey *accessToken;

@end

NS_ASSUME_NONNULL_END
