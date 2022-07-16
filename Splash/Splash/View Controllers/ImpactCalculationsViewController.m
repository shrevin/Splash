//
//  ImpactCalculationsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/15/22.
//

#import "ImpactCalculationsViewController.h"
#import "Parse/Parse.h"

@interface ImpactCalculationsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *gallonsPerWeekLabel;
@property (strong, nonatomic) IBOutlet UILabel *gallonsPerYearLabel;
@property (strong, nonatomic) IBOutlet UILabel *bgalPerWeekLabel;
@property (strong, nonatomic) IBOutlet UILabel *bgalPerYearLabel;
@property (strong, nonatomic) PFUser *user;
@end

@implementation ImpactCalculationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    int avgShowerTime = roundf([self.user[@"totalShowerTime"] intValue] / [self.user[@"numShowers"] intValue]);
    NSLog([NSString stringWithFormat:@"%i", self.waterFlow]);
    NSLog([NSString stringWithFormat:@"%i", self.showersPerWeek]);
    // multiply by avg. water flow
    // multiply by number of showers per week
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
