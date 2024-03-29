//
//  SpotifyAPIManager.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

#import "SpotifyAPIManager.h"
#import "Splash-Swift.h"
#import "TimeViewController.h"
#import "LoginViewController.h"
#import "Helper.h"

@implementation SpotifyAPIManager 

+ (instancetype)shared {
    static SpotifyAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)startConnection {
    self.configuration  = [[SPTConfiguration alloc] initWithClientID:@"54c6c371e13b4f8ab5e82bd97ff3f563" redirectURL:[NSURL URLWithString:@"splash://"]];
    NSURL *tokenSwapURL =  [NSURL URLWithString:@"http://localhost:1234/swap"];
    NSURL *tokenRefreshURL = [NSURL URLWithString:@"http://localhost:1234/refresh"];
    self.configuration.tokenSwapURL = tokenSwapURL;
    self.configuration.tokenRefreshURL = tokenRefreshURL;
    // playURI is empty, so playback of user’s last track is resumed
    self.configuration.playURI = @"";
    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
    self.sessionManager.delegate = self;
    SPTScope requestedScope = SPTAppRemoteControlScope;
    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    // initializing app remote
    [self initializeAppRemote];
}

- (void) initializeAppRemote {
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self.delegate;
}

#pragma mark - SPTSessionManagerDelegate
- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    DLog(@"success: %@", session);
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    self.token = session.accessToken;
    [self.appRemote connect];
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    DLog(@"renewed: %@", session);
}

-(void) setResponseCode:(NSString *)responseCode {
    _responseCode = responseCode;
    DLog(@"inside setter for response code");
    // CALL FETCH MOVIES IN HERE AND GET ACCESS TOKEN
    NetworkCalls* calls = [[NetworkCalls alloc]init];
    [calls fetchAccessTokenWithResponseCode:responseCode completion:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
        if (error) {
            DLog(@"error");
            return;
        }
        NSString *accessToken = dictionary[@"access_token"];
        self.appRemote.connectionParameters.accessToken = accessToken;
        self.token = accessToken;
        [self.appRemote connect];

    }];
    
}


@end
