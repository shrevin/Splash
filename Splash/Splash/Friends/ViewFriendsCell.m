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
    [user fetchIfNeeded];
    self.user = user;
    self.usernameLabel.text = user[@"username"];
    self.pic.layer.cornerRadius = self.pic.frame.size.height/2;
    self.pic.file = self.user[@"profile"];
    [self.pic loadInBackground];
}

@end
