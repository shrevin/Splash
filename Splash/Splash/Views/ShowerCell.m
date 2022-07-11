//
//  ShowerCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/8/22.
//

#import "ShowerCell.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "Shower.h"
#import "TimeViewController.h"


@implementation ShowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCell:(Shower *)s {
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
    self.profilePic.file = [PFUser currentUser][@"profile"];
    [self.profilePic loadInBackground];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocalizedDateFormatFromTemplate:@"EEEE, MMM d, yyyy"];
    self.dateLabel.text = [format stringFromDate:s.createdAt];
    self.lengthLabel.text = [TimeViewController formatTimeString:[[NSString stringWithFormat:@"%@", s[@"len"]] intValue]];
}

@end