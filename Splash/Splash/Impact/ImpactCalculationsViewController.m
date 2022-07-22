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
@property (strong, nonatomic) IBOutlet UILabel *savedGalPerWeek;
@property (strong, nonatomic) IBOutlet UILabel *savedGalPerYear;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UIView *backView1;
@property (strong, nonatomic) IBOutlet UIView *backView2;
@property (strong, nonatomic) IBOutlet UIView *backView3;


@end

@implementation ImpactCalculationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    // Do any additional setup after loading the view.
    float avgShowerTime = ([self.user[@"totalShowerTime"] floatValue] / [self.user[@"numShowers"] floatValue])/60;
    self.gallonsPerWeekLabel.text = [NSString stringWithFormat:@"%.2f", avgShowerTime * self.waterFlow * self.showersPerWeek];
    self.gallonsPerYearLabel.text = [NSString stringWithFormat:@"%.2f", avgShowerTime * self.waterFlow * self.showersPerWeek * 52.0];
    self.bgalPerWeekLabel.text = [NSString stringWithFormat:@"%.2f", (avgShowerTime - 1) * self.waterFlow * self.showersPerWeek];
    self.bgalPerYearLabel.text = [NSString stringWithFormat:@"%.2f", (avgShowerTime - 1) * self.waterFlow * self.showersPerWeek * 52];
    self.savedGalPerWeek.text = [NSString stringWithFormat:@"%.2f",[self.gallonsPerWeekLabel.text floatValue] - [self.bgalPerWeekLabel.text floatValue]];
    self.savedGalPerYear.text = [NSString stringWithFormat:@"%.2f",[self.gallonsPerYearLabel.text floatValue] - [self.bgalPerYearLabel.text floatValue]];
    self.backView1.layer.cornerRadius = 16;
    self.backView2.layer.cornerRadius = 16;
    self.backView3.layer.cornerRadius = 16;
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
