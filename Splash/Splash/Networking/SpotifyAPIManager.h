//
//  SpotifyAPIManager.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>

@class NetworkCalls;

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyAPIManager : NSObject <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
+ (instancetype)shared;
-(void)parseURL:(NSURL*)url;
- (void)startConnection;
@property SPTConfiguration *configuration;
@property SPTSessionManager *sessionManager;
@property SPTAppRemote *appRemote;
@property (nonatomic) NSString *responseCode;
@end

NS_ASSUME_NONNULL_END
