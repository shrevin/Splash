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

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profileImage;

@property (strong,nonatomic) NSArray *scoreNames;
//@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *pullDownButtonForPFP;

@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HomeViewController
NSString *HeaderViewIdentifier = @"TableViewHeaderView";
int totalTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    self.usernameLabel.text = self.user.username;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
   
    self.scoreNames = @[@"💪 Goal: ", @"🧼 Bubblescore: ", @"🔥 Streak: ", @"⏳ Avg. Shower Time: ", @"🕜 Total Shower Time: ", @"🚿 Number of Showers: "];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.user[@"profile"]) {
        self.profileImage.file = self.user[@"profile"];
        [self.profileImage loadInBackground];
    }
    UIAction *camera = [UIAction actionWithTitle:@"Take photo" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self clickCamera];
    }];
    UIAction *chooseLibary = [UIAction actionWithTitle:@"Choose from library" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self clickLibrary];
    }];
   
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:camera, chooseLibary, nil]];
    self.pullDownButtonForPFP.menu = menu;
    self.pullDownButtonForPFP.showsMenuAsPrimaryAction = YES;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
    self.tableView.sectionHeaderTopPadding = 0;
    
//    // Creating scrolling functionality
//    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    scrollView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:scrollView];
//    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height)];
//    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    redView.backgroundColor = [UIColor redColor];
//    [scrollView addSubview:redView];

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView
                                           dequeueReusableHeaderFooterViewWithIdentifier:HeaderViewIdentifier];
    return header;
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog([NSString stringWithFormat:@"%i", indexPath.section]);
    StatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStatsCell"];
    if (indexPath.section % 2) {
        [cell setBackgroundColor:[UIColor blackColor]];
    }
    NSString *name = self.scoreNames[indexPath.section];
    if (indexPath.section == 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.user[@"goal"]];
        int currMinute = [components minute];
        int currSeconds = [components second];
        [cell setCell:name value:[NSString stringWithFormat:@"%@", [TimeViewController formatTimeString:(currMinute*60) + currSeconds]]];
            //NSLog([NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]);
    } else if (indexPath.section == 1) {
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]];
    } else if (indexPath.section == 2) {
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"streak"]]];
    } else if (indexPath.section == 3) {
        int averageTime = roundf([self.user[@"totalShowerTime"] intValue] / [self.user[@"numShowers"] intValue]);
        [cell setCell:name value:[TimeViewController formatTimeString:averageTime]];
    } else if (indexPath.section ==  4){
        [cell setCell:name value:[TimeViewController formatTimeString:[self.user[@"totalShowerTime"] intValue]]];
    } else if (indexPath.section == 5){
            [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"numShowers"]]];
    } else {
            [cell setCell:name value:@"20"];
    }
    cell.layer.cornerRadius = 16;
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//     if (indexPath.section % 2) {
//         [cell setBackgroundColor:[UIColor blackColor]];
//     }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}



//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(self.collectionView.bounds.size.width/3, 150);
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 6;
//}
//
//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    StatsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stats" forIndexPath:indexPath];
//    NSString *name = self.scoreNames[indexPath.row];
//    if (indexPath.row == 1) {
//        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]];
//        //NSLog([NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]);
//    } else if (indexPath.row == 5){
//        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"numShowers"]]];
//    } else {
//        [cell setCell:name value:@"20"];
//    }
//    return cell;
//}

- (IBAction)clickLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        self.view.window.rootViewController = loginVC;
    }];
}


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
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"profile.png" data:imageData];
    PFUser *user = [PFUser currentUser];
    user[@"profile"] = imageFile;
    [user saveInBackground];
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
        NSLog(@"Camera 🚫 available so we will use photo library instead");
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
