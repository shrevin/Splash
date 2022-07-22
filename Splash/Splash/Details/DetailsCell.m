//
//  DetailsCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import "DetailsCell.h"

@implementation DetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell:(NSString *)type value:(NSString*)value {
    self.typeLabel.text = type;
    self.statLabel.text = value;
}

@end
