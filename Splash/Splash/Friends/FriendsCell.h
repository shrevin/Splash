//
//  FriendsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet PFImageView *friendPic;
@property (strong, nonatomic) PFUser *user;
-(void)setCell:(PFUser*)user;
@end

NS_ASSUME_NONNULL_END
