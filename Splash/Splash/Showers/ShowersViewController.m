//
//  ShowersViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ShowersViewController.h"
#import "ShowerCell.h"
#import "Parse/Parse.h"
#import "TimeViewController.h"
#import "Helper.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

@interface ShowersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *showersTableView;
@property (strong, nonatomic) NSMutableArray *showersArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (readwrite, nonatomic) id<DataLoaderProtocol> dataLoader;
@end

@implementation ShowersViewController
NSString *HeaderViewIdentifierForShowers = @"ShowerViewHeaderView";
const int kNumberOfRowsForShowers = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getShowerData];
    [self setUpTableView];
    [self setUpTapGesture];
}

# pragma  mark - Methods for setting up table view and tap gesture
- (void) setUpTableView {
    self.showersTableView.delegate = self;
    self.showersTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self.showersTableView insertSubview:self.refreshControl atIndex:0];
    self.showersTableView.layer.cornerRadius = 10.0;
    [self.showersTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifierForShowers];
    self.showersTableView.sectionHeaderTopPadding = 0;
    self.searchBar.delegate = self;
    self.filteredData = [[NSMutableArray alloc] init];
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.searchBar resignFirstResponder];
}

# pragma  mark - Methods for getting data
-(void) getShowerData {
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    self.showersArray = [[NSMutableArray alloc] init];
    [self.dataLoader getShowerData:^(NSMutableArray * arr) {
        self.showersArray = arr;
        self.filteredData = arr;
        [self.showersTableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

# pragma  mark - Table view data source and delegate methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifierForShowers];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsForShowers;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowerCell *cell = [self.showersTableView dequeueReusableCellWithIdentifier:@"showerCell"];
    [cell setCell:self.filteredData[indexPath.section]];
    cell.layer.cornerRadius = 25;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor grayColor] CGColor];
    return cell;
}

# pragma  mark - Methods for setting up the search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
       NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Shower *evaluatedShower, NSDictionary *bindings) {
           NSDateFormatter *format = [[NSDateFormatter alloc] init];
           [format setLocalizedDateFormatFromTemplate:@"EEEE, MMM d, yyyy"];
           return [[format stringFromDate:evaluatedShower.createdAt] containsString:searchText] || [[Helper formatTimeString:[[NSString stringWithFormat:@"%@", evaluatedShower[@"len"]] intValue]] containsString:searchText];
        }];
        self.filteredData = [self.showersArray filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredData = self.showersArray;
    }
    [self.showersTableView reloadData];
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
