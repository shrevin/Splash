//
//  DetailsCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/18/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statLabel;
-(void) setCell:(NSString*)title stat:(NSString*)stat;
@end

NS_ASSUME_NONNULL_END
