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
#import "Helper.h"

@interface AppDelegate ()
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
    NSDictionary *parameters = [[SpotifyAPIManager shared].appRemote authorizationParametersFromURL:url];
    if (parameters[@"code"] != nil) {
        [SpotifyAPIManager shared].responseCode = parameters[@"code"];
        DLog([NSString stringWithFormat:@"%@", [SpotifyAPIManager shared].responseCode]);
        DLog(@"response code not null");
    } else if (parameters[SPTAppRemoteAccessTokenKey] != nil){
        DLog(@"access token not null");
    } else if (parameters[SPTAppRemoteErrorDescriptionKey] != nil){
        DLog([NSString stringWithFormat:@"%@", [[SpotifyAPIManager shared].appRemote authorizationParametersFromURL:url][SPTAppRemoteErrorDescriptionKey]]);
    }
    return YES;
}

@end
