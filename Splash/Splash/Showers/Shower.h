//
//  Shower.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/8/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Shower : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *showerID;
@property (nonatomic, strong) NSNumber *len;
@property (nonatomic, strong) NSNumber *metGoal;
@property (nonatomic, strong) NSNumber *goal;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
