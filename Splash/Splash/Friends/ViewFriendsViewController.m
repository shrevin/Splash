//
//  ViewFriendsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/27/22.
//

#import "ViewFriendsViewController.h"
#import "SWTableViewCell.h"
#import "Parse/Parse.h"
#import "ViewFriendsCell.h"
#import "DetailsViewController.h"
#import "Helper.h"

@interface ViewFriendsViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friends;
@end

@implementation ViewFriendsViewController
NSArray *_rows;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) viewDidAppear:(BOOL)animated {
    [self getFriends];
}

- (void) getFriends {
    self.friends = [PFUser currentUser][@"friends"];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    ViewFriendsCell *cell = (ViewFriendsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    [cell setCell:self.friends[indexPath.row]];
    return cell;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];

    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(ViewFriendsCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        DLog(@"DELETEEE");
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        [[PFUser currentUser] removeObject:cell.user forKey:@"friends"];
        [[PFUser currentUser] saveInBackground];
        [self.friends removeObjectAtIndex:cellIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"SELECTED");
    ViewFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toDetails" sender:cell];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailsViewController *detailsVC = [segue destinationViewController];
    ViewFriendsCell *cell = sender;
    detailsVC.user = cell.user;
}


@end
