//
//  ButtonCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 8/3/22.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "Routine.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ButtonCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property id<DataLoaderProtocol> dataLoader;
- (void) customizeCell:(NSString *)label;
- (void) setColorOfTotal: (int) total;
@end

NS_ASSUME_NONNULL_END
