//
//  LeaderboardCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaderboardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bubblescoreValueLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong, nonatomic) PFUser *user;
@property (readwrite, nonatomic) id<DataLoaderProtocol> dataLoader;
-(void)setCell:(PFUser*)top_user;
@end

NS_ASSUME_NONNULL_END
