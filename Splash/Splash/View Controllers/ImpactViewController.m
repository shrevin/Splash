//
//  ImpactViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ImpactViewController.h"
#import "ImpactCalculationsViewController.h"

@interface ImpactViewController ()
@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UITextField *waterFlowTextField;
@property (strong, nonatomic) IBOutlet UITextField *showersTextField;

@end

@implementation ImpactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.calculateButton.layer.cornerRadius = 8;
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
    self.waterFlowTextField.delegate = self;
    self.showersTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImpactCalculationsViewController *impactCalc = [segue destinationViewController];
    impactCalc.waterFlow = [self.waterFlowTextField.text floatValue];
    impactCalc.showersPerWeek = [self.showersTextField.text intValue];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
