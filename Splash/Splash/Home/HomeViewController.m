//
//  HomeViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "StatsCell.h"
#import "LoginViewController.h"
#import "Parse/PFImageView.h"
#import "TimeViewController.h"
#import "Shower.h"
#import "Helper.h"
#import "Splash-Swift.h"
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profileImage;
@property (strong,nonatomic) NSArray *scoreNames;
@property (strong, nonatomic) IBOutlet UIButton *pullDownButtonForPFP;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *friendsButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (readwrite, nonatomic) id <DataLoaderProtocol> dataLoader;
@end

@implementation HomeViewController
NSString *HeaderViewIdentifier = @"TableViewHeaderView";
int totalTime;
const int kNumberOfRowsForHome = 1;
NSArray *descriptions = @[@"The time ranging from 2 minutes to 8 minutes that you can set for your showers. You can change this in settings. If you can't make your goal when showering, the timer will turn red and count up.", @"A number that determines how many times you met your goal. If you complete your shower before the clock turns red, your bubblescore will increase by 1!", @"The number of times you met your goal in a row!", @"The total number of showers you took divided by the total time you showered.", @"The sum of the times of all the showers you took.", @"The number of showers you choose to save in the app."];

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpTableView];
    [self configureChangeProfilePicButton];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
    NSArray *friends =  [self.dataLoader getFriends:[self.dataLoader getCurrentUser]];
    [self.friendsButton setTitle:[NSString stringWithFormat:@"%lu friends", (unsigned long)friends.count] forState:UIControlStateNormal];
}

#pragma mark - Action method for clicking logout button
- (IBAction)clickLogout:(id)sender {
    [self.dataLoader logout:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        self.view.window.rootViewController = loginVC;
    }];
}

#pragma mark - Helper methods for setting up view controller and pull down button
- (void) setUpView {
    self.dataLoader = [[ParseDataLoaderManager alloc]init];
    self.scoreNames = @[@"💪 Goal: ", @"🧼 Bubblescore: ", @"🔥 Streak: ", @"⏳ Avg. Shower Time: ", @"🕜 Total Shower Time: ", @"🚿 Number of Showers: "];
    self.usernameLabel.text = [self.dataLoader getUsername:[self.dataLoader getCurrentUser]];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.friendsButton.layer.cornerRadius = 16;
    [self.dataLoader getProfileImage:self.profileImage user:[PFUser currentUser]];
}

- (void) setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    self.tableView.sectionHeaderTopPadding = 0;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + self.tableView.bounds.size.height/2);
    self.tableView.scrollEnabled = NO;
}

- (void) configureChangeProfilePicButton {
    UIAction *camera = [UIAction actionWithTitle:@"Take photo" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self clickCamera];
    }];
    UIAction *chooseLibary = [UIAction actionWithTitle:@"Choose from library" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self clickLibrary];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:camera, chooseLibary, nil]];
    self.pullDownButtonForPFP.menu = menu;
    self.pullDownButtonForPFP.showsMenuAsPrimaryAction = YES;
}

#pragma mark - Table View Delegate and Data Source Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRowsForHome;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStatsCell"];
    NSString *name = self.scoreNames[indexPath.section];
    if (indexPath.section == 0) {
        [cell setCell:name value:[Helper formatDate:[self.dataLoader getGoal:[self.dataLoader getCurrentUser]]]];
    } else if (indexPath.section == 1) {
        [cell setCell:name value:[NSString stringWithFormat:@"%d", [self.dataLoader getBubblescore:[self.dataLoader getCurrentUser]]]];
    } else if (indexPath.section == 2) {
        [cell setCell:name value:[NSString stringWithFormat:@"%d", [self.dataLoader getStreak:[self.dataLoader getCurrentUser]]]];
    } else if (indexPath.section == 3) {
        int averageTime = roundf([self.dataLoader getTotalShowerTime:[self.dataLoader getCurrentUser]] / [self.dataLoader getNumShowers:[self.dataLoader getCurrentUser]]);
        [cell setCell:name value:[Helper formatTimeString:averageTime]];
    } else if (indexPath.section ==  4){
        [cell setCell:name value:[Helper formatTimeString:[self.dataLoader getTotalShowerTime:[self.dataLoader getCurrentUser]]]];
    } else if (indexPath.section == 5){
            [cell setCell:name value:[NSString stringWithFormat:@"%d", [self.dataLoader getNumShowers:[self.dataLoader getCurrentUser]]]];
    } else {
            [cell setCell:name value:@"20"];
    }
    cell.layer.cornerRadius = 25;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StatsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor lightGrayColor]];
    bgColorView.layer.cornerRadius = 25;
    [cell setSelectedBackgroundView:bgColorView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.scoreNames.count;
}

#pragma mark - Helper Methods for Setting Profile Picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    if (editedImage) {
        self.profileImage.image = editedImage;
    } else {
        self.profileImage.image = originalImage;
    }
    NSData *imageData = UIImagePNGRepresentation(self.profileImage.image);
    [self.dataLoader changeProfileImage: imageData];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickCamera{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        DLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)clickLibrary {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toDescriptions"]) {
        DescriptionViewController *descriptionVC = [segue destinationViewController];
        StatsCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        int index = indexPath.section;
        descriptionVC.label.text = descriptions[index];
    } else if ([segue.identifier isEqualToString:@"segueFromButton"]) {
        DescriptionViewController *descriptionVC = [segue destinationViewController];
        UIView *contentView = (UIView *)[(UIView *)sender superview];
        StatsCell *cell = (StatsCell*)[contentView superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        int index = indexPath.section;
        descriptionVC.label.text = descriptions[index];
    }
}

@end
