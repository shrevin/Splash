//
//  LoginViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "Helper.h"

@interface LoginViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@end

@implementation LoginViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    [self setUpTapGesture];
    [self animateImage];
    [self performSelector:@selector(changeImage) withObject:nil afterDelay:1.5];
}

- (void) setUpView {
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.usernameField.layer.cornerRadius = 16;
    self.passwordField.layer.cornerRadius = 16;
    self.signInButton.layer.cornerRadius = 16;
    self.passwordField.secureTextEntry = YES;
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)signInButton:(id)sender {
    if ([self.usernameField.text isEqual:@""]) {
        [Helper alertEmptyUsername];
    } else if ([self.passwordField.text isEqual:@""]) {
        [Helper alertEmptyPassword];
    } else {
        [self loginUser];
    }
}


- (void) animateImage {
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:INFINITY];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.image.center.x - 5,self.image.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(self.image.center.x + 5, self.image.center.y)]];
    [self.image.layer addAnimation:shake forKey:@"position"];
}

- (void) changeImage {
    self.image.image = [UIImage imageNamed:@"120"];
    [self.image.layer removeAnimationForKey:@"position"];
}



#pragma mark - Helper methods to login or register an user


- (void)loginUser {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a registered user" message:@"Please sign up" preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            DLog(@"User log in failed: %@", error.localizedDescription);
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];
        } else {
            DLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"segueFromLogin" sender:self];
            // display view controller that needs to shown after successful login
        }
    }];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITabBarController *tabs = [segue destinationViewController];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabs;
}
*/

@end
