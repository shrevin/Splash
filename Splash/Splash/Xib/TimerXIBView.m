//
//  TimerXIBView.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/25/22.
//

#import "TimerXIBView.h"
#import "Parse/Parse.h"
#import "Helper.h"
#import "Shower.h"
#import "SpotifyAPIManager.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

@interface TimerXIBView () <SPTAppRemoteDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property AVAudioPlayer *player;
@property (readwrite, nonatomic) id <DataLoaderProtocol> dataLoader;
@end

@implementation TimerXIBView
NSTimer *timerUp;
NSTimer *timerDown;
NSDateFormatter *format;
NSDate *startDate;
NSTimeInterval elapsedTime = 0;
int startMin;
int startSec;
int currMin;
int currSec;
CFTimeInterval start;
UIAlertController *alertForShower;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void) customInit {
    [[NSBundle mainBundle] loadNibNamed:@"TimerXIB" owner:self options:nil];
    [self addSubview:self.contentView];
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    self.contentView.frame = self.bounds;
    format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.startButton.layer.cornerRadius = 16;
    self.stopButton.layer.cornerRadius = 16;
    self.timeLabel.text = [format stringFromDate:[self.dataLoader getGoal:[self.dataLoader getCurrentUser]]];
    startDate = [self.dataLoader getGoal:[self.dataLoader getCurrentUser]];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    self.playingMusic = NO;
}

- (void) updateTime {
    self.timeLabel.text = [format stringFromDate:[self.dataLoader getGoal:[self.dataLoader getCurrentUser]]];
    startDate = [self.dataLoader getGoal:[self.dataLoader getCurrentUser]];
}

- (void) updateFontSize:(int)size {
    self.timeLabel.font = [UIFont systemFontOfSize:size];
}

- (IBAction)clickStart:(id)sender {
    start = CACurrentMediaTime();
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:startDate];
    currMin = [components minute];
    currSec = [components second];
    startMin = [components minute];
    startSec = [components second];
    timerDown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dateForFormatter) userInfo:nil repeats:true];
    self.startButton.hidden = YES;
    self.stopButton.hidden = NO;
}

- (IBAction)clickStop:(id)sender {
    [timerUp invalidate];
    [timerDown invalidate];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    self.timeLabel.text = [format stringFromDate:[self.dataLoader getGoal:[self.dataLoader getCurrentUser]]];
    currMin = startMin;
    currSec = startSec;
    self.timeLabel.textColor = [UIColor blackColor];
    CFTimeInterval elapsedTime = CACurrentMediaTime() - start;
    DLog([@"elapsed time: " stringByAppendingString: [NSString stringWithFormat:@"%f", elapsedTime]]);
    int goalSeconds = (startMin * 60) + startSec;
    DLog([NSString stringWithFormat:@"%i",goalSeconds]);
    int metGoal = goalSeconds - roundf(elapsedTime);
    DLog([NSString stringWithFormat:@"%i",metGoal]);
    [Helper requestToSaveShower:elapsedTime metGoal:metGoal goalSeconds:goalSeconds completion:^(UIAlertController * _Nonnull alert) {
        [self.root presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }];
}

#pragma mark - Helper Methods to Format Dates and Timer
-(void)dateForFormatter{
    if((currMin>0 || currSec>=0) && currMin>=0) {
        if(currSec==0) {
            currMin-=1;
            currSec=59;
        } else if(currSec>0) {
            currSec-=1;
        }
        if(currMin>-1) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSec + (currMin*60)];
            self.timeLabel.text = [format stringFromDate:date];
        } else {
            currMin = 0;
            currSec = 1;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSec + (currMin*60)];
            self.timeLabel.text = [format stringFromDate:date];
            self.timeLabel.textColor = [UIColor redColor];
            [timerDown invalidate];
            timerUp = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(goingPastZero) userInfo:nil repeats:true];
        }
        [self playSound:@"07:00" sound:@"7"];
        [self playSound:@"06:00" sound:@"6"];
        [self playSound:@"05:00" sound:@"5"];
        [self playSound:@"04:00" sound:@"4"];
        [self playSound:@"03:00" sound:@"3"];
        [self playSound:@"02:00" sound:@"2"];
        [self playSound:@"01:00" sound:@"1"];
        [self playSound:@"00:00" sound:@"overtime"];
    }
    
}

- (void) playSound:(NSString*)timeInterval sound:(NSString*)sound {
    if ([self.timeLabel.text isEqualToString:timeInterval]) {
        DLog(@"played sound");
        self.playingMusic = YES;
        NSString *path = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
        NSURL *url = [NSURL URLWithString:path];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [self.player play];
    }
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    DLog(@"error :(");
    [self performSelector:@selector(connect2Spotify) withObject:self afterDelay:0.1];
}

-(void)connect2Spotify
{
    if ([SpotifyAPIManager shared].appRemote!=nil)
    {
        if (![SpotifyAPIManager shared].appRemote.connected){
            [SpotifyAPIManager shared].appRemote.connectionParameters.accessToken = [SpotifyAPIManager shared].token;
            [[SpotifyAPIManager shared].appRemote connect];
        }
    }
}

- (void) playMusic {
    [[SpotifyAPIManager shared].appRemote.playerAPI resume:nil];
}

- (void) goingPastZero {
    currSec += 1;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:currSec + (currMin*60)];
    self.timeLabel.text = [format stringFromDate:date];
}

@end
