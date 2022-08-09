//
//  Helper.h
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject
+ (NSString*) formatTimeString:(int)secs;
+ (int) getRemainingSec: (int)secs;
+ (int) convertSecsToMin:(int)secs;
+ (NSString *) formatDate:(NSDate *)date;
+ (int) getGoalAsSeconds:(NSDate *)date;
+ (void) alertMessage:(NSString*) title message:(NSString*) message navigate:(BOOL)navigate completion1:(void (^)(void))completion1 completion2:(void (^)(UIAlertController *alert))completion2;
+ (void) requestToSaveShower:(CFTimeInterval)elapsedTime metGoal:(int)metGoal goalSeconds:(int)goalSeconds completion:(void (^)(UIAlertController *alert))completion;
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

@end

NS_ASSUME_NONNULL_END
