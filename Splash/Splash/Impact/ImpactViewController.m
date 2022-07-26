//
//  ImpactViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ImpactViewController.h"
#import "ImpactCalculationsViewController.h"

@interface ImpactViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;
@property (strong, nonatomic) IBOutlet UITextField *waterFlowTextField;
@property (strong, nonatomic) IBOutlet UITextField *showersTextField;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation ImpactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self setUpTapGesture];
}

- (void) setUpView {
    self.waterFlowTextField.delegate = self;
    self.showersTextField.delegate = self;
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.calculateButton.layer.cornerRadius = 8;
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.waterFlowTextField resignFirstResponder];
    [self.showersTextField resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ImpactCalculationsViewController *impactCalc = [segue destinationViewController];
    impactCalc.waterFlow = [self.waterFlowTextField.text floatValue];
    impactCalc.showersPerWeek = [self.showersTextField.text intValue];
}

@end
