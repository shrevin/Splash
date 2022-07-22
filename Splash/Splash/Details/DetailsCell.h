//
//  DetailsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *statLabel;
- (void)setCell:(NSString *)type value:(NSString*)value;
@end

NS_ASSUME_NONNULL_END
