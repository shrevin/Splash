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
#import "TimeViewController.h"
#import "SpotifyAPIManager.h"

@interface AppDelegate () // <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
//@property (nonatomic, strong) SPTSessionManager *sessionManager;
//@property (nonatomic, strong) SPTConfiguration *configuration;
//@property (nonatomic, strong) SPTAppRemote *appRemote;
@property(nonatomic, strong) TimeViewController *rootViewController;
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
    if (PFUser.currentUser) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedViewController"];
    }
    return YES;
}

// Once a user successfully returns to your application, we’ll need to notify sessionManager about it by implementing the following method:

//#pragma mark - UISceneSession lifecycle
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    if ([SpotifyAPIManager shared].appRemote.connectionParameters.accessToken != nil) {
        [[SpotifyAPIManager shared].appRemote connect];
    }
}

- (void) applicationWillResignActive:(UIApplication *)application {
    if ([SpotifyAPIManager shared].appRemote.isConnected) {
        [[SpotifyAPIManager shared].appRemote disconnect];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //[[SpotifyAPIManager shared] parseURL:url]; // just testing
    //[SpotifyAPIManager shared].responseCode = [[SpotifyAPIManager shared].appRemote authorizationParametersFromURL:url][@"code"];
    NSDictionary *parameters = [[SpotifyAPIManager shared].appRemote authorizationParametersFromURL:url];
    if (parameters[@"code"] != nil) {
        [SpotifyAPIManager shared].responseCode = parameters[@"code"];
        NSLog([NSString stringWithFormat:@"%@", [SpotifyAPIManager shared].responseCode]);
        NSLog(@"response code not null");
    } else if (parameters[SPTAppRemoteAccessTokenKey] != nil){
        //[SpotifyAPIManager shared].accessToken = parameters[SPTAppRemoteAccessTokenKey];
        NSLog(@"access token not null");
    } else if (parameters[SPTAppRemoteErrorDescriptionKey] != nil){
        NSLog([NSString stringWithFormat:@"%@", [[SpotifyAPIManager shared].appRemote authorizationParametersFromURL:url][SPTAppRemoteErrorDescriptionKey]]);
    }
    return YES;
}

@end
