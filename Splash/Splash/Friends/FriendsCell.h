//
//  FriendsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *friendName;
@property (strong, nonatomic) IBOutlet PFImageView *friendPic;
@property (strong, nonatomic) PFUser *user;
@property (readwrite, nonatomic) id <DataLoaderProtocol> dataLoader;
-(void)setCell:(PFUser*)user;
@end

NS_ASSUME_NONNULL_END
