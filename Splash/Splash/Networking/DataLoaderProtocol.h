//
//  DataLoaderProtocol.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/29/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DataLoaderProtocol 
- (void) registerUser: (NSString *)username password:(NSString *)password email:(NSString *)email;
- (void) loginUser: (NSString *)username password:(NSString *)password vc:(UIViewController *) vc segueId:(NSString *)segueId alert:(UIAlertController *)alert;
- (void) logout: (UIViewController *)vc;
- (void) getProfileImage: (PFImageView *)imageView user:(PFUser *)user;
- (NSString *) getGoal: (PFUser *)user;
- (int) getBubblescore: (PFUser *)user;
- (int) getStreak: (PFUser *)user;
- (int) getNumShowers: (PFUser *)user;
- (int) getTotalShowerTime: (PFUser *)user;
- (NSString *) getUsername: (PFUser *)user;
- (void) changeProfileImage: (NSData *)imageData;
- (void) addFriend: (PFUser *)user;
- (void) removeFriend: (PFUser *)user;
- (PFUser *) getCurrentUser;
- (void) updateGoal: (NSDate *)goal;
- (NSMutableArray *) getLeaderboardData;
- (NSDate *) getGoalAsDate: (PFUser *) user;
- (void) updateBubblescore: (PFUser *) user newScore:(int)newScore;
- (void) updateStreak: (PFUser *) user newStreak:(int)newStreak;
- (void) updateTotalShowerTime: (PFUser *) user newTime:(int)newTime;
- (void) updateNumShowers: (PFUser *) user newNum:(int)newNum;
- (NSArray *) getFriends: (PFUser *) user;
- (NSArray *) getPossibleNewFriends: (NSArray*)currFriends;
- (void) getShowerData: (NSMutableArray *) originalArray filteredArray:(NSMutableArray *)filteredArray tableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
