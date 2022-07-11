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

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profileImage;

@property (strong, nonatomic) IBOutlet UIPickerView *minutePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *secondPicker;
@property (strong,nonatomic) NSArray *scoreNames;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) PFUser *user;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [PFUser currentUser];
    self.usernameLabel.text = self.user.username;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.minutePicker.delegate = self;
    self.minutePicker.dataSource = self;
    self.secondPicker.delegate = self;
    self.secondPicker.dataSource = self;
    self.scoreNames = @[@"Your Goal", @"Bubblescore", @"Streak 🔥", @"Avg. Shower Time", @"Total Shower Time", @"# of Showers"];
    [self.minutePicker reloadAllComponents];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    if (self.user[@"profile"]) {
        self.profileImage.file = self.user[@"profile"];
        [self.profileImage loadInBackground];
    }
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width/3, 150);
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        return 7;
    } else {
        return 60;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
    if (pickerView.tag == 1) {
        return [NSString stringWithFormat:@"%ld", row + 1];
    } else {
        return [NSString stringWithFormat:@"%ld", row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StatsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stats" forIndexPath:indexPath];
    NSString *name = self.scoreNames[indexPath.row];
    if (indexPath.row == 1) {
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]];
        NSLog([NSString stringWithFormat:@"%@", self.user[@"bubblescore"]]);
    } else if (indexPath.row == 5){
        [cell setCell:name value:[NSString stringWithFormat:@"%@", self.user[@"numShowers"]]];
    } else {
        [cell setCell:name value:@"20"];
    }
    return cell;
}

- (IBAction)clickLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        self.view.window.rootViewController = loginVC;
    }];
}
- (IBAction)clickCamera:(id)sender {
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

- (IBAction)clickLibrary:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)clickSave:(id)sender {
    int minutes = [self.minutePicker selectedRowInComponent:0] + 1;
    int seconds = [self.secondPicker selectedRowInComponent:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm:ss.S";
    dateFormat.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *goal =[NSDate dateWithTimeIntervalSince1970:seconds + (minutes*60)];
    self.user[@"goal"] = goal;
    [self.user saveInBackground];
    //NSLog([dateFormat stringFromDate: goal]);
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
