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

- (void) setColorOfTotal: (int) total {
    int goal = [Helper getGoalAsSeconds:([self.dataLoader getGoal:([self.dataLoader getCurrentUser])])];
    if (total > goal) {
        self.totalTimeLabel.textColor = UIColor.redColor;
    } else {
        self.totalTimeLabel.textColor = UIColor.blackColor;
    }
    
}

@end
