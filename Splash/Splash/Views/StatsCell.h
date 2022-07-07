//
//  StatsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
- (void)setCell:(NSString *)type value:(NSString*)value;
@end

NS_ASSUME_NONNULL_END
