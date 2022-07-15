//
//  LeaderboardCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/11/22.
//

#import "LeaderboardCell.h"
#import "Parse/PFImageView.h"

@implementation LeaderboardCell


-(void)setCell:(PFUser*)top_user {
    self.usernameLabel.text = top_user[@"username"];
    self.bubblescoreValueLabel.text = [NSString stringWithFormat:@"%@", top_user[@"bubblescore"]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.file = top_user[@"profile"];
    [self.profileImage loadInBackground];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
