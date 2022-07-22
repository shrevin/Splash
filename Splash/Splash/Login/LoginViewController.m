//
//  LoginViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "Helper.h"


@interface LoginViewController () <UITextFieldDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (IBAction)signInButton:(id)sender {
    [self alertEmptyUsername];
    [self alertEmptyPassword];
    [self loginUser];
}

- (IBAction)registerButton:(id)sender {
    [self alertEmptyUsername];
    [self alertEmptyPassword];
    [self registerUser];
}

#pragma mark - Helper methods to login or register an user

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            DLog(@"Error: %@", error.localizedDescription);
        } else {
            DLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"segueFromLogin" sender:self];
            // manually segue to logged in view
        }
    }];
}

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

#pragma mark - Helper methods to display alerts for empty text fields

- (void) alertEmptyUsername {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Username" message:@"Please enter a username" preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        if ([self.usernameField.text isEqual:@""]) {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];
        }
}

- (void) alertEmptyPassword {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Password" message:@"Please enter a password" preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        if ([self.passwordField.text isEqual:@""]) {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];
        }
    
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
