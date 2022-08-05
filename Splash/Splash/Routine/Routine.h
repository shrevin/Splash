//
//  Routine.h
//  Splash
//
//  Created by Shreya Vinjamuri on 8/2/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Routine : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) PFUser *user;
@end

NS_ASSUME_NONNULL_END
