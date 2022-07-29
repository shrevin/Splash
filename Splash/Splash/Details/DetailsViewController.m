//
//  DetailsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/18/22.
//

#import "DetailsViewController.h"
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "DetailsCell.h"
#import "TimeViewController.h"
#import "StatsCell.h"
#import "Helper.h"

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) NSArray *scoreNames;
@property (strong, nonatomic) IBOutlet UITableView *detailsTableView;
@property (strong, nonatomic) IBOutlet UIButton *removeFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *challengeButton;
@property (strong, nonatomic) PFUser *current;
@property (strong, nonatomic) IBOutlet UIButton *onLBButton;
@property (strong, nonatomic) NSArray *friends;
@end

@implementation DetailsViewController
NSString *DetailsHeaderViewIdentifier = @"DetailsTableViewHeaderView";
const int kNumberOfRowsForDetails = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setupTableView];
    [self setUpScrollView];
    [self checkFriends];
    [self checkIfUserEqualsCurrent];
}

#pragma mark - Helper methods for setting up view, table view, and scroll view

- (void) setupTableView {
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    [self.detailsTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:DetailsHeaderViewIdentifier];
    self.detailsTableView.sectionHeaderTopPadding = 0;
}

- (void) setupView {
    self.usernameLabel.text = self.user[@"username"];
    self.profilePic.layer.cornerRadius = 16;
    self.profilePic.file = self.user[@"profile"];
    [self.profilePic loadInBackground];
    self.removeFriendButton.layer.cornerRadius = 16;
    self.addFriendButton.layer.cornerRadius = 16;
    self.challengeButton.layer.cornerRadius = 16;
    self.onLBButton.layer.cornerRadius = 16;
    self.addFriendButton.hidden = YES;
    self.removeFriendButton.hidden = YES;
    self.challengeButton.hidden = YES;
    self.onLBButton.hidden = YES;
    self.scoreNames = @[@"💪 Goal: ", @"🧼 Bubblescore: ", @"🔥 Streak: ", @"⏳ Avg. Shower Time: ", @"🕜 Total Shower Time: ", @"🚿 Number of Showers: "];
    self.current = [PFUser currentUser];
    self.friends = self.current[@"friends"];
}

- (void) setUpScrollView {
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height + self.detailsTableView.bounds.size.height/3.5);
    self.detailsTableView.scrollEnabled = NO;
}

#pragma mark - Helper Methods for Displaying Buttons Based on Friend Status

- (void) checkIfUserEqualsCurrent {
    if ([self.current.objectId isEqual:self.user.objectId]) {
        self.addFriendButton.hidden = YES;
        self.removeFriendButton.hidden = YES;
        self.challengeButton.hidden = YES;
        self.onLBButton.hidden = NO;
    }
}

- (void) checkFriends {
    self.friends = self.current[@"friends"];
    self.onLBButton.hidden = YES;
    if ([self hasUser:self.friends u:self.user]) {
        self.addFriendButton.hidden = YES;
        self.removeFriendButton.hidden = NO;
        self.challengeButton.hidden = NO;
        NSLog(@"FRIENDS");
    } else {
        self.addFriendButton.hidden = NO;
        self.challengeButton.hidden = YES;
        self.removeFriendButton.hidden = YES;
        NSLog(@"NOT FRIENDS");
    }
}

- (BOOL) hasUser:(NSArray*)my_arr u:(PFUser*)u {
    for (PFUser* p in my_arr) {
        if ([p.objectId isEqualToString:u.objectId]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action Methods for Buttons

- (IBAction)clickAdd:(id)sender {
    if (![self hasUser:self.friends u:self.user]) {
        [self.current addObject:self.user forKey:@"friends"];
        [self.current saveInBackground];
        DLog(@"ADDED FRIEND");
    }
    [self checkFriends];
}

- (IBAction)clickRemove:(id)sender {
    [self.current removeObject:self.user forKey:@"friends"];
    [self.current saveInBackground];
    DLog(@"REMOVED FRIEND");
    [self checkFriends];
}

- (IBAction)clickChallenge:(id)sender {
}

#pragma mark - Table View Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView
                                           dequeueReusableHeaderFooterViewWithIdentifier:DetailsHeaderViewIdentifier];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsForDetails;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.scoreNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell"];
    NSString *name = self.scoreNames[indexPath.section];
    if (indexPath.section == 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.user[@"goal"]];
        int currMinute = [components minute];
        int currSeconds = [components second];
        [cell setCell:name value:[NSString stringWithFormat:@"%@", [Helper formatTimeString:(currMinute*60) + currSeconds]]];
    } else if (indexPath.section == 1) {
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]];
    } else if (indexPath.section == 2) {
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"streak"]]];
    } else if (indexPath.section == 3) {
        int averageTime = roundf([self.user[@"totalShowerTime"] intValue] / [self.user[@"numShowers"] intValue]);
        [cell setCell:name value:[Helper formatTimeString:averageTime]];
    } else if (indexPath.section ==  4){
        [cell setCell:name value:[Helper formatTimeString:[self.user[@"totalShowerTime"] intValue]]];
    } else if (indexPath.section == 5){
            [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"numShowers"]]];
    } else {
            [cell setCell:name value:@"20"];
    }
    cell.layer.cornerRadius = 25;
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
