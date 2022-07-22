//
//  StatsCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "StatsCell.h"

@implementation StatsCell

- (void)setCell:(NSString *)type value:(NSString*)value {
    self.typeLabel.text = type;
    self.valueLabel.text = value;
}

@end
