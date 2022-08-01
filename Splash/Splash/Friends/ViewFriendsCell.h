//
//  ViewFriendsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/27/22.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewFriendsCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *pic;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *user;
@property ParseDataLoaderManager *dataLoader;
- (void) setCell:(PFUser *)user;
@end

NS_ASSUME_NONNULL_END
