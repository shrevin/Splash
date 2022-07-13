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

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    self.usernameLabel.text = self.user.username;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
   
    self.scoreNames = @[@"Your Goal", @"Bubblescore", @"Streak 🔥", @"Avg. Shower Time", @"Total Shower Time", @"# of Showers"];
   
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
    
    
}


- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStatsCell"];
    return cell;
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
