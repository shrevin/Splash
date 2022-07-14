//
//  ImpactViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ImpactViewController.h"

@interface ImpactViewController ()
@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIButton *calculateButton;

@end

@implementation ImpactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.background.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.background.layer setBorderWidth: 0.5];
    self.background.layer.cornerRadius = 16;
    self.calculateButton.layer.cornerRadius = 8;
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"Bradley Hand Bold" size:19];
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
