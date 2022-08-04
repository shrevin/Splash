//
//  DataLoaderProtocol.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/29/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "Routine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DataLoaderProtocol

#pragma mark - Sign Up
- (void) registerUser: (NSString *)username password:(NSString *)password email:(NSString *)email;

#pragma mark - Login / logout
- (void) loginUser: (NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion;
- (void) logout: (void (^)(void))completion;

#pragma mark - Getting stats for a user
- (NSDate *) getGoal: (PFUser *) user;
- (int) getBubblescore: (PFUser *)user;
- (int) getStreak: (PFUser *)user;
- (int) getNumShowers: (PFUser *)user;
- (int) getTotalShowerTime: (PFUser *)user;
- (NSString *) getUsername: (PFUser *)user;
- (PFUser *) getCurrentUser;

#pragma mark - Getting / changing profile picture
- (void) getProfileImage: (PFImageView *)imageView user:(PFUser *)user;
- (void) changeProfileImage: (NSData *)imageData;

#pragma mark - Getting details about friends
- (void) addFriend: (PFUser *)user;
- (void) removeFriend: (PFUser *)user;
- (NSArray *) getFriends: (PFUser *) user;
- (NSArray *) getPossibleNewFriends: (NSArray*)currFriends;

#pragma mark - Getting leaderboard info
- (NSMutableArray *) getLeaderboardData;

#pragma mark - Getting and posting shower info
- (void) getShowerData: (void (^)(NSMutableArray*))completion;
- (void) postShower:(NSNumber * _Nullable)len met:(NSNumber * _Nullable)metGoal g:(NSNumber * _Nullable )g completion:(PFBooleanResultBlock  _Nullable)completion;

#pragma mark - Updating stats for a user
- (void) updateGoal: (NSDate *)goal;
- (void) updateBubblescore: (PFUser *) user newScore:(int)newScore;
- (void) updateStreak: (PFUser *) user newStreak:(int)newStreak;
- (void) updateTotalShowerTime: (PFUser *) user newTime:(int)newTime;
- (void) updateNumShowers: (PFUser *) user newNum:(int)newNum;

#pragma mark - Getting creation time for any PFObject
- (NSDate *) getCreatedAt:(PFObject *)object;

#pragma mark - Getting and posting routine info
- (NSMutableArray *) getRoutineData;
- (void) postRoutine:(NSString * _Nullable)title time:(NSNumber *_Nullable)time completion:(PFBooleanResultBlock  _Nullable)completion;
- (NSString *) getTitleForRoutine: (Routine *)r;
- (int) getTimeForRoutine: (Routine *)r;
- (void) removeRoutine: (Routine *)routine;

@end

NS_ASSUME_NONNULL_END
