//
//  AppDelegate.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "Splash-Bridging-Header.h"

@interface AppDelegate () // <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"pcGK4ZTAKbDi1hqdAeouml86lzyfsSHQsOOC5Q36"; // <- UPDATE
            configuration.clientKey = @"08dJSHf3bYEECcWNk7TVAKUWV2KbfCFwG9oXXLg2"; // <- UPDATE
            configuration.server = @"https://parseapi.back4app.com";
        }];

        [Parse initializeWithConfiguration:config];
    
//    // defining client id
//    NSString *spotifyClientID = @"54c6c371e13b4f8ab5e82bd97ff3f563";
//    // defining redirect url
//    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"spotify-ios-quick-start://spotify-login-callback"];
//
//    // instantiating the SDK
//    self.configuration  = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
//
//    // Setting up token swap
//    NSURL *tokenSwapURL =  [NSURL URLWithString:@"https://splash-shower-app.herokuapp.com/api/token"];
//    NSURL *tokenRefreshURL = [NSURL URLWithString:@"https://splash-shower-app.herokuapp.com/api/refresh_token"];
//    self.configuration.tokenSwapURL = tokenSwapURL;
//    self.configuration.tokenRefreshURL = tokenRefreshURL;
//    // playURI is empty, so playback of user’s last track is resumed
//    self.configuration.playURI = @"";
//    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
//
//    // invoking the authorization screen
//    SPTScope requestedScope = SPTAppRemoteControlScope;
//    [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
//
//    // initalizing App Remote on a class-level closure
//    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
//    self.appRemote.delegate = self;
//    NSLog([NSString stringWithFormat:@"%i",self.appRemote.isConnected]);
//

    return YES;
}

// Once a user successfully returns to your application, we’ll need to notify sessionManager about it by implementing the following method:
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"RETURNED");
    [self.sessionManager application:app openURL:url options:options];
    return true;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#pragma mark - SPTSessionManagerDelegate

// method required from SPTSessionManagerDelegate
- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    // connecting to Spotify once a user successfully authenticates
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect]; // if this is successful, the appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote method will be invoked
    NSLog(@"success: %@", session);
}

// method required from SPTSessionManagerDelegate
- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"fail: %@", error);
}

// method required from SPTSessionManagerDelegate
- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}
//
//// SPTAppRemoteDelegate methods that allow us to see playback state
- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote
{
    // Connection was successful, you can begin issuing commands
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
          NSLog(@"error: %@", error.localizedDescription);
        } else {
            NSLog(@"connected");
        }
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(NSError *)error
{
  NSLog(@"disconnected");
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
{
  NSLog(@"failed");
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState
{
    NSLog(@"player state changed");
    NSLog(@"Track name: %@", playerState.track.name);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  if (self.appRemote.isConnected) {
    [self.appRemote disconnect];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  if (self.appRemote.connectionParameters.accessToken) {
    [self.appRemote connect];
  }
}

@end
