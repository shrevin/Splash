//
//  HomeViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/6/22.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "StatsCell.h"

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIPickerView *goalPicker;
@property (strong,nonatomic) NSArray *goalData;
@property (strong,nonatomic) NSArray *scoreNames;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.goalPicker.delegate = self;
    self.goalPicker.dataSource = self;
    self.goalData = @[@"1 min", @"2 min", @"3 min", @"4 min", @"5 min", @"6 min", @"7 min", @"8 min"];
    self.scoreNames = @[@"Your Goal", @"Bubblescore", @"Streak 🔥", @"Avg. Shower Time", @"Total Shower Time", @"# of Showers"];
    [self.goalPicker reloadAllComponents];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
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
    return self.goalData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
    return self.goalData[row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StatsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"stats" forIndexPath:indexPath];
    NSString *name = self.scoreNames[indexPath.row];
    [cell setCell:name value:@"20"];
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
