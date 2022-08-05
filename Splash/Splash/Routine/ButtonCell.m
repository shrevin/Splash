//
//  ButtonCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 8/3/22.
//

#import "ButtonCell.h"

@implementation ButtonCell

- (void) customizeCell:(NSString *)label {
    self.startButton.layer.cornerRadius = 16;
    self.totalTimeLabel.text = label;
}

@end
