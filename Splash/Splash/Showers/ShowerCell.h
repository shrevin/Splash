//
//  ShowerCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "Shower.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
- (void) setCell:(Shower *)s;
@end

NS_ASSUME_NONNULL_END
