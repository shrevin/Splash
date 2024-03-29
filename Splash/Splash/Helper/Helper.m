//
//  Helper.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import "Helper.h"


@implementation Helper
#pragma mark - Helper methods to get dates and times
+ (int) getRemainingSec: (int)secs {
    return secs - ([self convertSecsToMin:secs] * 60);
}

+ (int) convertSecsToMin:(int)secs {
    return floorf(secs / 60);
}

+ (NSString*) formatTimeString:(int)secs {
    return [[[[[NSString stringWithFormat: @"%i", [self convertSecsToMin:secs]] stringByAppendingString:@"m"] stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat: @"%i", [self getRemainingSec:secs]]] stringByAppendingString:@"s"];
}

+ (NSString *) formatDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    int currMinute = [components minute];
    int currSeconds = [components second];
    return [NSString stringWithFormat:@"%@", [Helper formatTimeString:(currMinute*60) + currSeconds]];
}

+ (int) getGoalAsSeconds:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    int currMinute = [components minute];
    int currSeconds = [components second];
    return (currMinute*60) + currSeconds;
}

#pragma mark - Helper method to display alerts for empty text fields
+ (void) alertMessage:(NSString*) title message:(NSString*) message navigate:(BOOL)navigate completion1:(void (^)(void))completion1 completion2:(void (^)(UIAlertController *alert))completion2{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (navigate) {
            completion1();
        }
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    completion2(alert);
}

#pragma mark - Helper method to save shower data
+ (void) requestToSaveShower:(CFTimeInterval)elapsedTime metGoal:(int)metGoal goalSeconds:(int)goalSeconds completion:(void (^)(UIAlertController *alert))completion {
    id <DataLoaderProtocol> dataLoader = [ParseDataLoaderManager new];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Shower"
                                                                               message:[@"Time: " stringByAppendingString:[Helper formatTimeString:roundf(elapsedTime)]]
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { // handle cancel response here. Doing nothing will dismiss the view.
    }];
    [alert addAction:cancelAction];
    // create an OK action
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
        [dataLoader postShower:@(roundf(elapsedTime)) met:@(metGoal) g:@(goalSeconds) completion:^(BOOL succeeded, NSError * _Nullable error) {
            if (error == nil) {
                DLog(@"SUCCESSFULLY SAVED SHOWER");
                if (metGoal >= 0) {
                    [dataLoader updateBubblescore:[dataLoader getCurrentUser] newScore:[dataLoader getBubblescore:[dataLoader getCurrentUser]] + 1];
                    [dataLoader updateStreak:[dataLoader getCurrentUser] newStreak:[dataLoader getStreak:[dataLoader getCurrentUser]] + 1];
                } else {
                    [dataLoader updateStreak:[dataLoader getCurrentUser] newStreak:0];
                }
                int newTime = [dataLoader getTotalShowerTime:[dataLoader getCurrentUser]] + roundf(elapsedTime);
                [dataLoader updateTotalShowerTime:[dataLoader getCurrentUser] newTime:newTime];
                int numShowers = [dataLoader getNumShowers:[dataLoader getCurrentUser]];
                [dataLoader updateNumShowers:[dataLoader getCurrentUser] newNum:numShowers + 1];
            } else {
                DLog(@"did not save shower");
            }
        }];
        
    }];
    // add the OK action to the alert controller
    [alert addAction:saveAction];
    completion(alert);
}

@end
