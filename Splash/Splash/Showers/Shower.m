//
//  Shower.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/8/22.
//

#import "Shower.h"

@implementation Shower
@dynamic  showerID;
@dynamic len;
@dynamic metGoal;
@dynamic goal;
@dynamic user;

+ (nonnull NSString *)parseClassName {
       return @"Shower";
}

+ (void) postShower:(NSNumber * _Nullable )len met:(NSNumber * _Nullable )met g:(NSNumber * _Nullable )g completion:(PFBooleanResultBlock  _Nullable)completion {
    Shower *newShower = [Shower new];
    newShower[@"len"] = len;
    newShower[@"metGoal"] = met;
    newShower[@"goal"] = g;
    newShower[@"user"] = [PFUser currentUser];
    [newShower saveInBackgroundWithBlock: completion];
}

@end
