//
//  LeaderboardViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "LeaderboardViewController.h"
#import "LeaderboardCell.h"

@interface LeaderboardViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *leaderboardTableView;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leaderboardTableView.delegate = self;
    self.leaderboardTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardCell *cell = [self.leaderboardTableView dequeueReusableCellWithIdentifier:@"lbcell"];
    return cell;
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
