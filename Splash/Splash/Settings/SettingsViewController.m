//
//  SettingsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutlet UIPickerView *minPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *secPicker;

@end

@implementation SettingsViewController
const int kNumberOfRowsForSettings = 1;
const int kNumberOfMinutes = 7;
const int kNumberOfSeconds = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    self.minPicker.delegate = self;
    self.minPicker.dataSource = self;
    self.secPicker.delegate = self;
    self.secPicker.dataSource = self;
}

- (void) setUpView {
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.updateButton.layer.cornerRadius = 8;
}


#pragma mark - UIPickerView Delegate and DataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return kNumberOfRowsForSettings;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        return kNumberOfMinutes;
    } else {
        return kNumberOfSeconds;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
    if (pickerView.tag == 1) {
        return [NSString stringWithFormat:@"%ld", row + 1];
    } else {
        return [NSString stringWithFormat:@"%ld", row];
    }
}

#pragma mark - Action Methods for Buttons

- (IBAction)clickUpdate:(id)sender {
    PFUser *user = [PFUser currentUser];
    int minutes = [self.minPicker selectedRowInComponent:0] + 1;
    int seconds = [self.secPicker selectedRowInComponent:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss.S";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *goal =[NSDate dateWithTimeIntervalSince1970:seconds + (minutes*60)];
    user[@"goal"] = goal;
    [user saveInBackground];
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
