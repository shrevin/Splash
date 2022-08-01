//
//  FriendsCell.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import "FriendsCell.h"
#import "Parse/Parse.h"

@implementation FriendsCell
-(void)setCell:(PFUser*)user {
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    self.friendName.text = [self.dataLoader getUsername:user];
    self.friendPic.layer.cornerRadius = self.friendPic.frame.size.height/2;
    [self.dataLoader getProfileImage:self.friendPic user:user];
    self.friendPic.layer.borderWidth = 2;
    self.friendPic.layer.borderColor = ([UIColor colorWithRed:0.779 green:0.897 blue:0.934 alpha:1]).CGColor;
    self.user = user;
}
@end
