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
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (readwrite, nonatomic) id <DataLoaderProtocol> dataLoader;
- (void) setCell:(Shower *)s;
@end

NS_ASSUME_NONNULL_END
