//
//  NoMusicViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/19/22.
//

#import "NoMusicViewController.h"
#import "Parse/Parse.h"
#import "TimerXIBView.h"
#import "Helper.h"

@interface NoMusicViewController ()
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet TimerXIBView *stopwatch;
@end

@implementation NoMusicViewController
NSTimer *upTimerNoMusic;
NSTimer *downTimerNoMusic;
NSDateFormatter *dateFormatNoMusic;
NSDate *dateAtStartNoMusic;
NSTimeInterval elapsedTimeAtStopNoMusic = 0;
int startMinuteNoMusic;
int startSecondsNoMusic;
int currMinuteNoMusic;
int currSecondsNoMusic;
CFTimeInterval startTimeNoMusic;
UIAlertController *alertNoMusic;
bool isPausedNoMusic;

- (void) viewDidLoad {
    self.stopwatch.root = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.stopwatch updateTime];
    [self.stopwatch updateFontSize:120];
    DLog(@"APPEARED");
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
