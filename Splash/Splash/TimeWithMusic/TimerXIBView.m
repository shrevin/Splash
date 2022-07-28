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

@interface TimerXIBView () <SPTAppRemoteDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) PFUser *user;
@property AVAudioPlayer *player;
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
    self.contentView.frame = self.bounds;
    format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"mm:ss";
    format.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.user = [PFUser currentUser];
    self.startButton.layer.cornerRadius = 16;
    self.stopButton.layer.cornerRadius = 16;
    self.timeLabel.text = [format stringFromDate: self.user[@"goal"]];
    startDate = self.user[@"goal"];
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
}

- (void) updateTime {
    self.timeLabel.text = [format stringFromDate: self.user[@"goal"]];
    startDate = self.user[@"goal"];
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
    self.timeLabel.text = [format stringFromDate: self.user[@"goal"]];
    currMin = startMin;
    currSec = startSec;
    self.timeLabel.textColor = [UIColor blackColor];
    CFTimeInterval elapsedTime = CACurrentMediaTime() - start;
    DLog([@"elapsed time: " stringByAppendingString: [NSString stringWithFormat:@"%f", elapsedTime]]);
    int goalSeconds = (startMin * 60) + startSec;
    DLog([NSString stringWithFormat:@"%i",goalSeconds]);
    int metGoal = goalSeconds - roundf(elapsedTime);
    DLog([NSString stringWithFormat:@"%i",metGoal]);
    [self requestToSaveShower:elapsedTime metGoal:metGoal goalSeconds:goalSeconds];
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
        [[SpotifyAPIManager shared].appRemote.playerAPI pause:nil];
        DLog(@"played sound");
        NSString *path = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
        NSURL *url = [NSURL URLWithString:path];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [self.player play];
        [self performSelector:@selector(playMusic) withObject:self afterDelay:5.0];
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

- (void) requestToSaveShower:(CFTimeInterval)elapsedTime metGoal:(int)metGoal goalSeconds:(int)goalSeconds {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Shower"
                                                                               message:[@"Time: " stringByAppendingString:[Helper formatTimeString:roundf(elapsedTime)]]
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { // handle cancel response here. Doing nothing will dismiss the view.
    }];
    [alert addAction:cancelAction];
    // create an OK action
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        [Shower postShower:@(roundf(elapsedTime)) met:@(metGoal) g:@(goalSeconds) completion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                DLog(@"SUCCESSFULLY SAVED SHOWER");
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
                DLog(@"did not save shower");
            }
        }];
        
    }];
    // add the OK action to the alert controller
    [alert addAction:saveAction];
    [self.root presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
}

@end
