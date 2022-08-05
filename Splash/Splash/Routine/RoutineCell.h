//
//  RoutineCell.h
//  Splash
//
//  Created by Shreya Vinjamuri on 8/2/22.
//

#import <UIKit/UIKit.h>
#import "Routine.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"
#import "Helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoutineCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property id<DataLoaderProtocol> dataLoader;
- (void) setCell:(Routine *) r;
@end

NS_ASSUME_NONNULL_END
