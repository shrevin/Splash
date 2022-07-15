//
//  TimeViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "TimeViewController.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "Shower.h"
#import "SpotifyAPIManager.h"



@interface TimeViewController () <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;


@end

@implementation TimeViewController
NSTimer *upTimer;
NSTimer *downTimer;
NSDateFormatter *dateFormat;
NSDate *dateAtStart;
NSTimeInterval elapsedTimeAtStop = 0;
int startMinute;
int startSeconds;
int currMinute;
int currSeconds;
CFTimeInterval startTime;
UIAlertController *alert;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startButton.layer.cornerRadius = 40;
    self.stopButton.layer.cornerRadius = 40;
    dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.user = [PFUser currentUser];
    self.songLabel.text = @"hi";
    
    
//    // SPOTIFY SDK Authorization & Configuration
//    self.configuration  = [[SPTConfiguration alloc] initWithClientID:@"54c6c371e13b4f8ab5e82bd97ff3f563" redirectURL:[NSURL URLWithString:@"splash://"]];
//    NSURL *tokenSwapURL =  [NSURL URLWithString:@"http://localhost:1234/swap"];
//    NSURL *tokenRefreshURL = [NSURL URLWithString:@"http://localhost:1234/refresh"];
//    self.configuration.tokenSwapURL = tokenSwapURL;
//    self.configuration.tokenRefreshURL = tokenRefreshURL;
//    // playURI is empty, so playback of user’s last track is resumed
//    self.configuration.playURI = @"";
    

}


- (void) viewDidAppear:(BOOL)animated {
    self.stopwatchLabel.text = [dateFormat stringFromDate: self.user[@"goal"]];
    dateAtStart = self.user[@"goal"];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;

}


- (void) setSongImage: (UIImage*) song_image {
    self.songImage.image = song_image;
}

- (void) setSongLabel: (NSString*) song_label {
    self.songLabel.text = song_label;
 
}


-(void)dateForFormatter{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0) {
        if(currSeconds==0) {
            currMinute-=1;
            currSeconds=59;
        } else if(currSeconds>0) {
            currSeconds-=1;
        }
        if(currMinute>-1) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSeconds + (currMinute*60)];
            self.stopwatchLabel.text = [dateFormat stringFromDate:date];
        } else {
            currMinute = 0;
            currSeconds = 1;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSeconds + (currMinute*60)];
            self.stopwatchLabel.text = [dateFormat stringFromDate:date];
            self.stopwatchLabel.textColor = [UIColor redColor];
            [downTimer invalidate];
            upTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goingPastZero) userInfo:nil repeats:true];
        }
    }
    
}

- (void) goingPastZero {
    if (currSeconds < 60) {
        currSeconds+=1;
    } else {
        currMinute +=1;
        currSeconds = 0;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSeconds + (currMinute*60)];
    self.stopwatchLabel.text = [dateFormat stringFromDate:date];
}


- (IBAction)clickStart:(id)sender {
    startTime = CACurrentMediaTime();
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:dateAtStart];
    currMinute = [components minute];
    currSeconds = [components second];
    startMinute = [components minute];
    startSeconds = [components second];
    downTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dateForFormatter) userInfo:nil repeats:true];
    self.startButton.hidden = YES;
    self.stopButton.hidden = NO;
    
}



- (IBAction)clickStop:(id)sender {
    [upTimer invalidate];
    [downTimer invalidate];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    self.stopwatchLabel.text = [dateFormat stringFromDate: self.user[@"goal"]];
    currMinute = startMinute;
    currSeconds = startSeconds;
    self.stopwatchLabel.textColor = [UIColor blackColor];
    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
    NSLog([@"elapsed time: " stringByAppendingString: [NSString stringWithFormat:@"%f", elapsedTime]]);
    int goalSeconds = (startMinute * 60) + startSeconds;
    NSLog([NSString stringWithFormat:@"%i",goalSeconds]);
    int metGoal = goalSeconds - roundf(elapsedTime);
    NSLog([NSString stringWithFormat:@"%i",metGoal]);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Shower"
                                                                               message:[@"Time: " stringByAppendingString:[TimeViewController formatTimeString:roundf(elapsedTime)]]
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { // handle cancel response here. Doing nothing will dismiss the view.
    }];
    [alert addAction:cancelAction];
    // create an OK action
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        [Shower postShower:@(roundf(elapsedTime)) met:@(metGoal) g:@(goalSeconds) completion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"SUCCESSFULLY SAVED SHOWER");
                if (metGoal >= 0) {
                    self.user[@"bubblescore"] = @([self.user[@"bubblescore"] intValue] + 1);
                    NSNumber *streak = self.user[@"streak"];
                    self.user[@"streak"] = @([streak intValue] + 1);
                    //[self.user saveInBackground];
                } else {
                    self.user[@"streak"] = @(0);
                    //[self.user saveInBackground];
                }
                self.user[@"totalShowerTime"] = @([self.user[@"totalShowerTime"] intValue] + roundf(elapsedTime));
                self.user[@"numShowers"] = @([self.user[@"numShowers"] intValue] + 1);
                [self.user saveInBackground];
            } else {
                NSLog(@"did not save shower");
            }
        }];
        
    }];
    // add the OK action to the alert controller
    [alert addAction:saveAction];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}


+ (int) getRemainingSec: (int)secs {
    return secs - ([self convertSecsToMin:secs] * 60);
}

+ (int) convertSecsToMin:(int)secs {
    return floorf(secs / 60);
}

+ (NSString*) formatTimeString:(int)secs {
    return [[[[[NSString stringWithFormat: @"%i", [self convertSecsToMin:secs]] stringByAppendingString:@"m"] stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat: @"%i", [self getRemainingSec:secs]]] stringByAppendingString:@"s"];
}


// METHODS THAT HAVE TO DO WITH SPOTIFY SDK
- (IBAction)clickConnect:(id)sender {
    [[SpotifyAPIManager shared] startConnection];
}


//#pragma mark - SPTSessionManagerDelegate
//
//- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
//{
//    NSLog(@"success: %@", session);
//    self.appRemote.connectionParameters.accessToken = session.accessToken;
//    [self.appRemote connect];
//}
//
//- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
//{
//  NSLog(@"fail: %@", error);
//}
//
//- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
//{
//  NSLog(@"renewed: %@", session);
//}
//
//#pragma mark - SPTAppRemoteDelegate
//
//- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote
//{
//  NSLog(@"connected");
//}
//
//- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(NSError *)error
//{
//  NSLog(@"disconnected");
//}
//
//- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
//{
//    NSLog(@"failed");
//    // Connection was successful, you can begin issuing commands
//      self.appRemote.playerAPI.delegate = self;
//      [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
//        if (error) {
//          NSLog(@"error: %@", error.localizedDescription);
//        }
//      }];
//}
//
//- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState
//{
//    NSLog(@"player state changed");
//    NSLog(@"Track name: %@", playerState.track.name);
//}

//
//- (void) updateViewBasedOnConnected {
//    if (appRemote.isConnected == true) {
//        self.connectButton.hidden = YES;
//        self.songImage.hidden = NO;
//        self.songLabel.hidden = NO;
//        self.playPauseButton.hidden = NO;
//    }
//    else { // show login
//        self.connectButton.hidden = NO;
//        self.songImage.hidden = YES;
//        self.songLabel.hidden = YES;
//        self.playPauseButton.hidden = YES;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
