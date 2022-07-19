//
//  DetailsCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/18/22.
//

#import "DetailsCell.h"

@implementation DetailsCell
-(void) setCell:(NSString*)title stat:(NSString*)stat {
    self.titleLabel.text = title;
    self.statLabel.text = stat;
}
@end
