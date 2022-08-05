//
//  ViewFriendsCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/27/22.
//

#import "ViewFriendsCell.h"

@implementation ViewFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCell:(PFUser *)user {
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    [user fetchIfNeeded];
    self.user = user;
    self.usernameLabel.text = [self.dataLoader getUsername:user];
    self.pic.layer.cornerRadius = self.pic.frame.size.height/2;
    [self.dataLoader getProfileImage:self.pic user:user];
}

@end
