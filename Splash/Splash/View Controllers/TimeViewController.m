//
//  TimeViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "TimeViewController.h"
#import "Parse/Parse.h"
#import <SpotifyiOS/SpotifyiOS.h>
#import "Shower.h"
#import "SpotifyAPIManager.h"
#import "Splash-Swift.h"
#import "NoMusicViewController.h"
#import <UIKit/UIKit.h>





@interface TimeViewController () <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate, SPTAppRemotePlaybackRestrictions>
@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UIButton *skipForwardButton;
@property (strong, nonatomic) IBOutlet UIButton *skipBackwardsButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property NoMusicViewController *noMusicVC;


//@property (assign, nonatomic) NSInteger index; // allows us to control which screen is shown in page view controller



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
bool isPaused;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startButton.layer.cornerRadius = 16;
    self.stopButton.layer.cornerRadius = 16;
    dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.user = [PFUser currentUser];
    self.songImage.layer.cornerRadius = 16;
    self.connectButton.layer.cornerRadius = 16;
    self.connectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.connectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.connectButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.startButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.stopButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.songImage.hidden = YES;
    self.playPauseButton.hidden = YES;
    self.skipForwardButton.hidden = YES;
    self.skipBackwardsButton.hidden = YES;
    // container view controller part
    self.noMusicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"noMusic"];
    [self addChildViewController:self.noMusicVC];
    [self.view addSubview:self.noMusicVC.view];
    [self.noMusicVC didMoveToParentViewController:self];
    self.noMusicVC.view.frame = self.view.bounds;
}


- (void) viewDidAppear:(BOOL)animated {
    self.noMusicVC.view.hidden = YES;
    self.stopwatchLabel.text = [dateFormat stringFromDate: self.user[@"goal"]];
    dateAtStart = self.user[@"goal"];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
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


- (IBAction)tapSegment:(id)sender {
    
    if (self.segment.selectedSegmentIndex == 1) {
        self.noMusicVC.view.hidden = NO;
    } else {
        self.noMusicVC.view.hidden = YES;
        
    }
    
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
    [self requestToSaveShower:elapsedTime metGoal:metGoal goalSeconds:goalSeconds];
    
}

- (void) requestToSaveShower:(CFTimeInterval)elapsedTime metGoal:(int)metGoal goalSeconds:(int)goalSeconds {
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


// Methods to Use Spotify SDK
- (IBAction)clickConnect:(id)sender {
    [[SpotifyAPIManager shared] startConnection];
}

- (IBAction)clickPlayPause:(id)sender {
    if (isPaused) {
        [[SpotifyAPIManager shared].appRemote.playerAPI resume:nil];
        UIImage *image = [UIImage imageNamed:@"pause"];
        [self.playPauseButton setImage:image forState:normal];
        isPaused = NO;
    } else {
        [[SpotifyAPIManager shared].appRemote.playerAPI pause:nil];
        isPaused = YES;
        UIImage *image = [UIImage imageNamed:@"play"];
        [self.playPauseButton setImage:image forState:normal];
    }
}


# pragma  mark - SPTAppRemoteDelegate
- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote {
    NSLog(@"SUCCESSFULLY CONNECTED");
    self.connectButton.hidden = YES;
    self.songImage.hidden = NO;
    self.playPauseButton.hidden = NO;
    self.skipForwardButton.hidden = NO;
    self.skipBackwardsButton.hidden = NO;
    appRemote.playerAPI.delegate = self;
    [appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"THERE IS AN ERROR (INSIDE appRemoteDidEstablishConnection)");
            }
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"error :(");
}



- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"error :(");
}


- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState {
    NSLog(@"PLAYER STATE CHANGED");
    isPaused = playerState.isPaused;
    NSLog([NSString stringWithFormat:@"Spotify Track name: %@", playerState.track.name]);
    NSString *name = [NSString stringWithFormat:@"%@", playerState.track.name];
    self.songLabel.text = name;
    NetworkCalls* calls = [[NetworkCalls alloc]init];
    [calls fetchArtworkFor:playerState.track appRemote:[SpotifyAPIManager shared].appRemote im_view:self.songImage];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
