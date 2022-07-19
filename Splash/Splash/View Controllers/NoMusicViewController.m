//
//  NoMusicViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/19/22.
//

#import "NoMusicViewController.h"
#import "Parse/Parse.h"

@interface NoMusicViewController ()
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) PFUser *user;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startButton.layer.cornerRadius = 16;
    self.stopButton.layer.cornerRadius = 16;
    self.startButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.stopButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    dateFormatNoMusic = [[NSDateFormatter alloc] init];
    dateFormatNoMusic.dateFormat = @"mm:ss";
    dateFormatNoMusic.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.user = [PFUser currentUser];
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.timeLabel.text = [dateFormatNoMusic stringFromDate: self.user[@"goal"]];
    dateAtStartNoMusic = self.user[@"goal"];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
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
