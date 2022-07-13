//
//  SpotifyAPIManager.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyAPIManager : NSObject <SPTSessionManagerDelegate>
+ (instancetype)shared;
-(void)parseURL:(NSURL*)url;
- (void)startConnection;
@property SPTConfiguration *configuration;
@property SPTSessionManager *sessionManager;
@property SPTAppRemote *appRemote;
@property NSString *responseCode;
@end

NS_ASSUME_NONNULL_END
