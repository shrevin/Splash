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
#import "Helper.h"
#import <UIKit/UIKit.h>
#import "TimerXIBView.h"

@interface TimeViewController () <SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate, SPTAppRemotePlaybackRestrictions>
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UILabel *songLabel;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UIButton *skipForwardButton;
@property (strong, nonatomic) IBOutlet UIButton *skipBackwardsButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property NoMusicViewController *noMusicVC;
@property RoutineViewController *routineVC;
@property (strong, nonatomic) IBOutlet TimerXIBView *stopwatchMusicScreen;
@end

@implementation TimeViewController
bool isPaused;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self setUpContainerVC];
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.segment.selectedSegmentIndex == 0) {
        self.noMusicVC.view.hidden = YES;
        self.routineVC.view.hidden = YES;
    }
    [self.stopwatchMusicScreen updateTime];
}

#pragma mark - Setting up view and container view controller
- (void) setUpView {
    self.stopwatchMusicScreen.root = self;
    self.songImage.layer.cornerRadius = 16;
    self.connectButton.layer.cornerRadius = 16;
    self.connectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.connectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.connectButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.songImage.hidden = YES;
    self.playPauseButton.hidden = YES;
    self.skipForwardButton.hidden = YES;
    self.skipBackwardsButton.hidden = YES;
}

- (void) setUpContainerVC {
    self.noMusicVC = [self.storyboard instantiateViewControllerWithIdentifier:@"noMusic"];
    [self addChildViewController:self.noMusicVC];
    [self.view addSubview:self.noMusicVC.view];
    [self.noMusicVC didMoveToParentViewController:self];
    self.noMusicVC.view.frame = self.view.bounds;
    self.routineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"routineVC"];
    [self addChildViewController:self.routineVC];
    [self.view addSubview:self.routineVC.view];
    [self.routineVC didMoveToParentViewController:self];
    self.routineVC.view.frame = self.view.bounds;
}

#pragma mark - Action methods for clicking buttons and changing segment
- (IBAction)tapSegment:(id)sender {
    
    if (self.segment.selectedSegmentIndex == 1) {
        self.noMusicVC.view.hidden = NO;
        self.routineVC.view.hidden = YES;
        [self.noMusicVC reloadInputViews];
    } else if (self.segment.selectedSegmentIndex == 0){
        self.noMusicVC.view.hidden = YES;
        self.routineVC.view.hidden = YES;
    } else {
        self.routineVC.view.hidden = NO;
        self.noMusicVC.view.hidden = YES;
    }
}

# pragma  mark - Methods for Spotify SDK
- (IBAction)clickConnect:(id)sender {
    [SpotifyAPIManager shared].delegate = self;
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
    DLog(@"SUCCESSFULLY CONNECTED");
    self.connectButton.hidden = YES;
    self.songImage.hidden = NO;
    self.playPauseButton.hidden = NO;
    self.skipForwardButton.hidden = NO;
    self.skipBackwardsButton.hidden = NO;
    appRemote.playerAPI.delegate = self;
    [appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
            if (error) {
                DLog(@"THERE IS AN ERROR (INSIDE appRemoteDidEstablishConnection)");
            }
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    DLog(@"error :(");
}

-(void)connect2Spotify
{
    [[SpotifyAPIManager shared] startConnection];
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    DLog(@"error :(");
    if (self.stopwatchMusicScreen.playingMusic) {
        [self performSelector:@selector(connect2Spotify) withObject:self afterDelay:0.1];
        self.stopwatchMusicScreen.playingMusic = NO;
    }
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState {
    DLog(@"PLAYER STATE CHANGED");
    isPaused = playerState.isPaused;
    DLog([NSString stringWithFormat:@"Spotify Track name: %@", playerState.track.name]);
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
