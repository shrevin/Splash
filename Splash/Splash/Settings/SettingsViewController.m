//
//  SettingsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/13/22.
//

#import "SettingsViewController.h"
#import "Parse/Parse.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) IBOutlet UIPickerView *minPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *secPicker;
@property ParseDataLoaderManager *dataLoader;
@end

@implementation SettingsViewController
const int kNumberOfRowsForSettings = 1;
const int kNumberOfMinutes = 9;
const int kNumberOfSeconds = 60;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (void) setUpView {
    self.dataLoader = [[ParseDataLoaderManager alloc]init];
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.updateButton.layer.cornerRadius = 8;
    self.minPicker.delegate = self;
    self.minPicker.dataSource = self;
    self.secPicker.delegate = self;
    self.secPicker.dataSource = self;
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
        return [NSString stringWithFormat:@"%ld", row + 2];
    } else {
        return [NSString stringWithFormat:@"%ld", row];
    }
}

#pragma mark - Action Methods for Buttons

- (IBAction)clickUpdate:(id)sender {
    int minutes = [self.minPicker selectedRowInComponent:0] + 2;
    int seconds = [self.secPicker selectedRowInComponent:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss.S";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *goal =[NSDate dateWithTimeIntervalSince1970:seconds + (minutes*60)];
    [self.dataLoader updateGoal:goal];
    [Helper alertMessage:@"Success! 🥳" message:[NSString stringWithFormat:@"Your new goal is %d minutes and %d seconds.", minutes, seconds]];

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
