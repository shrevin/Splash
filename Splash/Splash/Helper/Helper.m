//
//  Helper.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import "Helper.h"
#import "Parse/Parse.h"

@implementation Helper
+ (int) getRemainingSec: (int)secs {
    return secs - ([self convertSecsToMin:secs] * 60);
}

+ (int) convertSecsToMin:(int)secs {
    return floorf(secs / 60);
}

+ (NSString*) formatTimeString:(int)secs {
    return [[[[[NSString stringWithFormat: @"%i", [self convertSecsToMin:secs]] stringByAppendingString:@"m"] stringByAppendingString:@" "] stringByAppendingString:[NSString stringWithFormat: @"%i", [self getRemainingSec:secs]]] stringByAppendingString:@"s"];
}

#pragma mark - Helper methods to display alerts for empty text fields


+ (void) alertMessage:(NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
            
        }];
}
@end
