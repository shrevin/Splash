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
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    self.usernameLabel.text = [self.dataLoader getUsername:top_user];
    self.bubblescoreValueLabel.text = [NSString stringWithFormat:@"%d", [self.dataLoader getBubblescore:top_user]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    [self.dataLoader getProfileImage:self.profileImage user:top_user];
    self.user = top_user;
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
