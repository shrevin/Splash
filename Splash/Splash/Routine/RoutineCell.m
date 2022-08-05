//
//  RoutineCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 8/2/22.
//

#import "RoutineCell.h"

@implementation RoutineCell

- (void) setCell:(Routine *) r {
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    self.titleLabel.text = [self.dataLoader getTitleForRoutine:r.fetchIfNeeded];
    self.timeLabel.text = [Helper formatTimeString:[self.dataLoader getTimeForRoutine:r.fetchIfNeeded]];
}

@end
