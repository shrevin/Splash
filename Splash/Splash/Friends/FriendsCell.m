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
    self.friendName.text = user[@"username"];
    self.friendPic.layer.cornerRadius = self.friendPic.frame.size.height/2;
    self.friendPic.file = user[@"profile"];
    [self.friendPic loadInBackground];
    self.user = user;
}
@end
