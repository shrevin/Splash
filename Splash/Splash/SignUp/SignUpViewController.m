//
//  SignUpViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/28/22.
//

#import "SignUpViewController.h"

@interface SignUpViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UILabel *invalidPasswordText;
@property (readwrite, nonatomic) id <DataLoaderProtocol> dataLoader;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    [self setUpTapGesture];
    [self setUpView];
}

- (void) viewDidAppear:(BOOL)animated {
    [self animateLogo];
    [self performSelector:@selector(changeImage) withObject:nil afterDelay:3.0];
}

#pragma mark - Helper methods to set up view and tap gesture
- (void) setUpView {
    self.signUpButton.layer.cornerRadius = 16;
    self.passwordField.secureTextEntry = YES;
    self.invalidPasswordText.hidden = YES;
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Registering a user
- (IBAction)clickSignUp:(id)sender {
    if ([self.emailField.text isEqualToString:@""]) {
        [Helper alertMessage:@"Missing email" message:@"Please enter an email" navigate:NO completion1:^{} completion2:^(UIAlertController * _Nonnull alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else if ([self.usernameField.text isEqualToString:@""]) {
        [Helper alertMessage:@"Missing username" message:@"Please enter a username" navigate:NO completion1:^{} completion2:^(UIAlertController * _Nonnull alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else if ([self.passwordField.text isEqualToString:@""]) {
        [Helper alertMessage:@"Missing password" message:@"Please enter a password" navigate:NO completion1:^{} completion2:^(UIAlertController * _Nonnull alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } else if (![self isValidPassword:self.passwordField.text]) {
        self.invalidPasswordText.hidden = NO;
    } else {
        [self.dataLoader registerUser:self.usernameField.text password:self.passwordField.text email:self.emailField.text];
        //[self registerUser];
        [self performSegueWithIdentifier:@"toHome" sender:self];
    }
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser.email = self.emailField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            DLog(@"Error: %@", error.localizedDescription);
        } else {
            DLog(@"User registered successfully");
        }
    }];
}

#pragma mark - Configuring tap gesture to dismiss keyboard
- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Configuring logo's animation
- (void) animateLogo {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:INFINITY];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.logo.center.x - 5,self.logo.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(self.logo.center.x + 5, self.logo.center.y)]];
    [self.logo.layer addAnimation:shake forKey:@"position"];
}

- (void) changeImage {
    self.logo.image = [UIImage imageNamed:@"splash"];
    [self.logo.layer removeAnimationForKey:@"position"];
}

#pragma mark - Method to make sure password is atleast 8 characters with one special character and one number
-(BOOL)isValidPassword:(NSString *)checkString{
    NSError *error = NULL;
    // password requirements for 8 characters, at least one uppercase letter and one digit
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:checkString options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [checkString length])];
    if (numberOfMatches != 0) {
        DLog(@"MATCHES REQUIREMENTS");
        return YES;
    } else {
        DLog(@"DOESN'T MATCH");
        return NO;
    }
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
