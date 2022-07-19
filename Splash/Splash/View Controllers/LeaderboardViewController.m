//
//  LeaderboardViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "LeaderboardViewController.h"
#import "LeaderboardCell.h"
#import "Parse/Parse.h"
#import "DetailsViewController.h"

@interface LeaderboardViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (strong, nonatomic) NSMutableArray *leaderboard;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation LeaderboardViewController
NSString *HeaderViewIdentifierForLeaderboard = @"LeaderboardViewHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLeaderboardData];
    self.leaderboardTableView.delegate = self;
    self.leaderboardTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.leaderboardTableView.layer.cornerRadius = 10.0;
    [self.leaderboardTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifierForLeaderboard];
    self.leaderboardTableView.sectionHeaderTopPadding = 0;
    [self.refreshControl addTarget:self action:@selector(getLeaderboardData) forControlEvents:UIControlEventValueChanged];
    [self.leaderboardTableView insertSubview:self.refreshControl atIndex:0];
}

- (void) getLeaderboardData {
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"bubblescore"];
    query.limit = 10;
    self.leaderboard = [query findObjects];
    [self.refreshControl endRefreshing];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView
                                           dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifierForLeaderboard];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardCell *cell = [self.leaderboardTableView dequeueReusableCellWithIdentifier:@"lbcell"];
    [cell setCell:self.leaderboard[indexPath.section]];
    NSLog([NSString stringWithFormat:@"%i", indexPath.section]);
    cell.layer.cornerRadius = 16;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor grayColor] CGColor];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailsViewController *detailsVC = [segue destinationViewController];
    LeaderboardCell *cell = sender;
    detailsVC.user = cell.user;
}


@end
