//
//  ImpactViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ImpactViewController.h"
#import "Splash-Swift.h"
#import "Helper.h"

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

#pragma mark - Setting up views and tap gesture
- (void) setUpView {
    self.waterFlowTextField.delegate = self;
    self.showersTextField.delegate = self;
    self.waterFlowTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.showersTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.calculateButton.layer.cornerRadius = 8;
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Handling tap gesture to dismiss keybooard
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

#pragma mark - Action methods for buttons
- (IBAction)clickCalculate:(id)sender {
    if ([self.waterFlowTextField.text isEqualToString:@""] || [self.showersTextField.text isEqualToString:@""]) {
        [Helper alertMessage:@"Empty fields" message:@"Please fill in all fields." navigate:NO completion1:^{} completion2:^(UIAlertController * _Nonnull alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else {
        [self performSegueWithIdentifier:@"toImpact" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    VisualizeImpactViewController *visualizeVC = [segue destinationViewController];
    visualizeVC.waterFlow = [self.waterFlowTextField.text floatValue];
    visualizeVC.showersPerWeek = [self.showersTextField.text floatValue];
}


@end
