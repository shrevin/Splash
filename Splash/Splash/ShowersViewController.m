//
//  ShowersViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "ShowersViewController.h"
#import "ShowerCell.h"
#import "Parse/Parse.h"

@interface ShowersViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *showersTableView;
@property (strong, nonatomic) NSArray *showersArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation ShowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showersTableView.delegate = self;
    self.showersTableView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self getData];
    [self.refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self.showersTableView insertSubview:self.refreshControl atIndex:0];
 
}

-(void) getData {
    PFQuery *query = [PFQuery queryWithClassName:@"Shower"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
        // The find succeeded.
          self.showersArray = objects;
          [self.showersTableView reloadData];
      } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showersArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowerCell *cell = [self.showersTableView dequeueReusableCellWithIdentifier:@"showerCell"];
    [cell setCell:self.showersArray[indexPath.row]];
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
