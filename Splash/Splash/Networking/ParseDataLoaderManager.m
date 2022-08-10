//
//  ParseDataLoaderManager.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/29/22.
//

#import "ParseDataLoaderManager.h"


@implementation ParseDataLoaderManager


#pragma mark - Sign Up
- (void) registerUser: (NSString *)username password:(NSString *)password email:(NSString *)email completion:(void (^)(void))completion {
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
        completion();
    }];
}

#pragma mark - Login / logout
- (void) loginUser: (NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        completion(error);
    }];
}

- (void) logout: (void (^)(void))completion {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        completion();
    }];
}

#pragma mark - Getting stats for a user
- (NSDate *) getGoal: (PFUser *) user {
    return user[@"goal"];
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

- (PFUser *) getCurrentUser {
    return [PFUser currentUser];
}

#pragma mark - Getting / changing profile picture
- (void) getProfileImage: (PFImageView *)imageView user:(PFUser *)user {
    imageView.file = user[@"profile"];
    [imageView loadInBackground];
}

// changing the current user's profile image
- (void) changeProfileImage: (NSData *)imageData {
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    PFUser *user = [PFUser currentUser];
    user[@"profile"] = imageFile;
    [user saveInBackground];
}

#pragma mark - Getting details about friends + adding and removing friends
- (void) addFriend: (PFUser *)user {
    [[PFUser currentUser] addObject:user forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
}

- (void) removeFriend: (PFUser *)user {
    [[PFUser currentUser] removeObject:user forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
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

#pragma mark - Getting leaderboard info
- (NSMutableArray *) getLeaderboardData {
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"bubblescore"];
    query.limit = 10;
    return [query findObjects];
}

#pragma mark - Getting shower info

- (void) getShowerData: (void (^)(NSMutableArray*))completion {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Shower"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
        // The find succeeded.
        for (int i = objects.count - 1; i >= 0; i = i - 1) {
            [arr addObject:objects[i]];
        }
        completion(arr);
        } else {
        // Log details of the failure
          DLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
}

- (void) postShower:(NSNumber * _Nullable )len met:(NSNumber * _Nullable )met g:(NSNumber * _Nullable )g completion:(PFBooleanResultBlock  _Nullable)completion {
    Shower *newShower = [Shower new];
    newShower[@"len"] = len;
    newShower[@"metGoal"] = met;
    newShower[@"goal"] = g;
    newShower[@"user"] = [PFUser currentUser];
    [newShower saveInBackgroundWithBlock: completion];
}

#pragma mark - Updating stats for a user
- (void) updateGoal: (NSDate *)goal {
    [PFUser currentUser][@"goal"] = goal;
    [[PFUser currentUser] saveInBackground];
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

#pragma mark - Getting creation time for any PFObject
- (NSDate *) getCreatedAt:(PFObject *)object {
    return object.createdAt;
}

#pragma mark - Getting and posting routine info

- (NSMutableArray *) getRoutineData {
    return [PFUser currentUser][@"routineArray"];
}


- (void) postRoutine:(NSString * _Nullable)title time:(NSNumber *_Nullable)time completion:(PFBooleanResultBlock  _Nullable)completion{
    Routine *newRoutine = [Routine new];
    newRoutine[@"title"] = title;
    newRoutine[@"time"] = time;
    newRoutine[@"user"] = [PFUser currentUser];
    [newRoutine saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        [[PFUser currentUser] addObject:newRoutine forKey:@"routineArray"];
        [[PFUser currentUser] saveInBackgroundWithBlock:completion];
    }];
}

- (NSString *) getTitleForRoutine: (Routine *)r {
    [r fetchIfNeeded];
    return r[@"title"];
}

- (int) getTimeForRoutine: (Routine *)r {
    NSNumber *time = r[@"time"];
    return [time intValue];
}

- (void) removeRoutine: (Routine *)routine {
    [[PFUser currentUser] removeObject:routine forKey:@"routineArray"];
    [[PFUser currentUser] saveInBackground];
    [routine deleteInBackground];
}

- (void) updateRoutineArray:(NSArray *)routineArr {
    [PFUser currentUser][@"routineArray"] = routineArr;
    [[PFUser currentUser] saveInBackground];
}



@end
