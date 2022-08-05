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
@end
