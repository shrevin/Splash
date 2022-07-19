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

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profilePic;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *scoreNames;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.usernameLabel.text = self.user[@"username"];
    self.profilePic.layer.cornerRadius = 16;
    self.profilePic.file = self.user[@"profile"];
    [self.profilePic loadInBackground];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.scoreNames = @[@"💪 Goal ", @"🧼 Bubblescore", @"🔥 Streak ", @"⏳ Avg. Shower Time ", @"🕜 Total Shower Time ", @"🚿 Number of Showers "];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailsCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 16;
    [cell setCell:self.scoreNames[indexPath.row] stat:@"20"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.collectionView.bounds.size.width)/ 3 - 10, self.collectionView.window.bounds.size.height/6);
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
