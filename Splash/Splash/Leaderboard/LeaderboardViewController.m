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

@interface LeaderboardViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *leaderboardTableView;
@property (strong, nonatomic) NSMutableArray *leaderboard;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *filteredLeaderboard;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LeaderboardViewController
NSString *HeaderViewIdentifierForLeaderboard = @"LeaderboardViewHeaderView";
const int kNumberOfRowsForLeaderboard = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getLeaderboardData];
    [self setUpTableView];
    [self setUpTapGesture];
}

- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.searchBar resignFirstResponder];
}

#pragma mark - Helper methods to fetch data and set up views

- (void) getLeaderboardData {
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"bubblescore"];
    query.limit = 10;
    self.leaderboard = [query findObjects];
    self.filteredLeaderboard = self.leaderboard;
    [self.refreshControl endRefreshing];
}

- (void) setUpTableView {
    self.leaderboardTableView.delegate = self;
    self.leaderboardTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getLeaderboardData) forControlEvents:UIControlEventValueChanged];
    self.leaderboardTableView.layer.cornerRadius = 10.0;
    [self.leaderboardTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifierForLeaderboard];
    self.leaderboardTableView.sectionHeaderTopPadding = 0;
    [self.leaderboardTableView insertSubview:self.refreshControl atIndex:0];
    self.searchBar.delegate = self;
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Search Bar Delegate Method

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"username"] containsString:searchText] || [[evaluatedObject[@"bubblescore"] stringValue] containsString:searchText];
        }];
        self.filteredLeaderboard = [self.leaderboard filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredLeaderboard = self.leaderboard;
    }
    [self.leaderboardTableView reloadData];
}

#pragma mark - Table View DataSource Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView
                                           dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifierForLeaderboard];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsForLeaderboard;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filteredLeaderboard.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardCell *cell = [self.leaderboardTableView dequeueReusableCellWithIdentifier:@"lbcell"];
    [cell setCell:self.filteredLeaderboard[indexPath.section]];
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
