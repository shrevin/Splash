//
//  ParseDataLoaderManager.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/29/22.
//

#import "ParseDataLoaderManager.h"
#import "ShowerCell.h"

@implementation ParseDataLoaderManager
- (void) registerUser: (NSString *)username password:(NSString *)password email:(NSString *)email {
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            DLog(@"Error: %@", error.localizedDescription);
        } else {
            DLog(@"User registered successfully");
        }
    }];
}

- (void) loginUser: (NSString *)username password:(NSString *)password vc:(UIViewController *) vc segueId:(NSString *)segueId alert:(UIAlertController *)alert{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            DLog(@"User log in failed: %@", error.localizedDescription);
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{}];
        } else {
            DLog(@"User logged in successfully");
            [vc performSegueWithIdentifier:@"segueFromLogin" sender:self];
            // display view controller that needs to shown after successful login
        }
    }];
}

- (NSArray *) getFriends {
    return [PFUser currentUser][@"friends"];
}

- (void) logout: (UIViewController *)vc {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        vc.view.window.rootViewController = loginVC;
    }];
}

- (void) getProfileImage: (PFImageView *)imageView user:(PFUser *)user {
    imageView.file = user[@"profile"];
    [imageView loadInBackground];
}

// getting the current user's goal stat
- (NSString *) getGoal: (PFUser *)user {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[PFUser currentUser][@"goal"]];
    int currMinute = [components minute];
    int currSeconds = [components second];
    return [NSString stringWithFormat:@"%@", [Helper formatTimeString:(currMinute*60) + currSeconds]];
}

// getting the current user's bubblescore stat
- (int) getBubblescore: (PFUser *)user {
    return [user[@"bubblescore"] intValue];
}

// getting the current user's streak stat
- (int) getStreak: (PFUser *)user {
    return [user[@"streak"] intValue];
}

// getting the current user's number of showers
- (int) getNumShowers: (PFUser *)user {
    return [user[@"numShowers"] intValue];
}

// getting the current user's total shower time
- (int) getTotalShowerTime: (PFUser *)user {
    return [user[@"totalShowerTime"] intValue];
}

- (NSString *) getUsername: (PFUser *)user {
    return user.username;
}

// changing the current user's profile image
- (void) changeProfileImage: (NSData *)imageData {
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    PFUser *user = [PFUser currentUser];
    user[@"profile"] = imageFile;
    [user saveInBackground];
}

- (void) addFriend: (PFUser *)user {
    [[PFUser currentUser] addObject:user forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
}

- (void) removeFriend: (PFUser *)user {
    [[PFUser currentUser] removeObject:user forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
}

- (PFUser *) getCurrentUser {
    return [PFUser currentUser];
}

- (void) updateGoal: (NSDate *)goal {
    [PFUser currentUser][@"goal"] = goal;
    [[PFUser currentUser] saveInBackground];
}

- (NSMutableArray *) getLeaderboardData {
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"bubblescore"];
    query.limit = 10;
    return [query findObjects];
}

- (NSDate *) getGoalAsDate: (PFUser *) user {
    return user[@"goal"];
}

- (void) updateBubblescore: (PFUser *) user newScore:(int)newScore {
    user[@"bubblescore"] = @(newScore);
    [user saveInBackground];
}

- (void) updateStreak: (PFUser *) user newStreak:(int)newStreak {
    user[@"streak"] = @(newStreak);
    [user saveInBackground];
}

- (void) updateTotalShowerTime: (PFUser *) user newTime:(int)newTime {
    user[@"totalShowerTime"] = @(newTime);
    [user saveInBackground];
}

- (void) updateNumShowers: (PFUser *) user newNum:(int)newNum {
    user[@"numShowers"] = @(newNum);
    [user saveInBackground];
}

- (NSArray *) getFriends: (PFUser *) user {
    return user[@"friends"];
}

- (NSArray *) getPossibleNewFriends: (NSArray*)currFriends {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notContainedIn:currFriends];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    return [query findObjects];
}

- (void) getShowerData: (NSMutableArray *) originalArray filteredArray:(NSMutableArray *)filteredArray tableView:(UITableView *)tableView {
    PFQuery *query = [PFQuery queryWithClassName:@"Shower"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSArray *copy = objects;
        if (objects.count != 0) {
        // The find succeeded.
          for (int i = objects.count - 1; i >= 0; i = i - 1) {
              [originalArray addObject:objects[i]];
          }
          __block NSMutableArray *filteredArray = originalArray;
          NSLog([NSString stringWithFormat:@"%d", filteredArray.count]);
          [tableView reloadData];
        } else {
        // Log details of the failure
          DLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
    NSLog([NSString stringWithFormat:@"%d", filteredArray.count]);
}


@end
