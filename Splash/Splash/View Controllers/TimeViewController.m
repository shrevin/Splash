//
//  TimeViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "TimeViewController.h"
#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>


@interface TimeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *stopwatchLabel;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;


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
NSDate *start;
CFTimeInterval startTime;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startButton.layer.cornerRadius = 40;
    self.stopButton.layer.cornerRadius = 40;
    dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss.S";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    self.user = [PFUser currentUser];
}

- (void) viewDidAppear:(BOOL)animated {
    self.stopwatchLabel.text = [dateFormat stringFromDate: self.user[@"goal"]];
    dateAtStart = self.user[@"goal"];

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
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:dateAtStart];
    currMinute = [components minute];
    currSeconds = [components second];
    startMinute = [components minute];
    startSeconds = [components second];
    downTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dateForFormatter) userInfo:nil repeats:true];
    self.startButton.hidden = YES;
    start = [NSDate date];
    startTime = CACurrentMediaTime();
    
}



- (IBAction)clickStop:(id)sender {
    [upTimer invalidate];
    [downTimer invalidate];
    self.startButton.hidden = NO;
    self.stopwatchLabel.text = [dateFormat stringFromDate: self.user[@"goal"]];
    currMinute = startMinute;
    currSeconds = startSeconds;
    self.stopwatchLabel.textColor = [UIColor blackColor];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    NSLog([NSString stringWithFormat:@"%d", timeInterval]);
    CFTimeInterval elapsedTime = CACurrentMediaTime() - startTime;
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
