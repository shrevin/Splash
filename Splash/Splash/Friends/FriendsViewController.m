//
//  FriendsViewController.m
//  Splash
//
//  Created by Shreya Vinjamuri on 7/21/22.
//

#import "FriendsViewController.h"
#import "Parse/Parse.h"
#import "FriendsCell.h"
#import "DetailsViewController.h"

@interface FriendsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *possible_friends;
@property (strong, nonatomic) NSMutableArray *friendsIds;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friendsIds = [[NSMutableArray alloc]init];
    [self populateFriendsId];
    [self getData];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
   
    
}

- (void) populateFriendsId {
    NSArray *friendsList = [PFUser currentUser][@"friends"];
    for (PFUser *user in friendsList) {
        [self.friendsIds addObject:user.objectId];
    }
}
- (void) getData {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notContainedIn:self.friendsIds];
    self.possible_friends = [query findObjects];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.possible_friends.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"friendsCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 30;
    [cell setCell:self.possible_friends[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.window.bounds.size.width/2 - 30, self.collectionView.window.bounds.size.height/3);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DetailsViewController *detailsVC = [segue destinationViewController];
    FriendsCell *cell = sender;
    detailsVC.user = cell.user;
}


@end
