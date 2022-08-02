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
#import "DataLoaderProtocol.h"
#import "ParseDataLoaderManager.h"

@interface FriendsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *possibleFriends;
@property (strong, nonatomic) NSMutableArray *possibleFriendsFiltered;
@property (strong, nonatomic) NSMutableArray *friendsIds;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property ParseDataLoaderManager *dataLoader;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataLoader = [[ParseDataLoaderManager alloc] init];
    [self setUpCollectionView];
    [self populateFriendsId];
    [self getData];
    [self setUpTapGesture];
}

- (void) viewDidAppear:(BOOL)animated {
    [self populateFriendsId];
    [self getData];
}

#pragma mark - Setting up views

- (void) setUpCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void) setUpTapGesture {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Getting data

- (void) populateFriendsId {
    self.friendsIds = [[NSMutableArray alloc]init];
    NSArray *friendsList = [self.dataLoader getFriends:[PFUser currentUser]];
    for (PFUser *user in friendsList) {
        [self.friendsIds addObject:user.objectId];
    }
}
- (void) getData {
    self.possibleFriends = [self.dataLoader getPossibleNewFriends:self.friendsIds];
    self.possibleFriendsFiltered = self.possibleFriends;
    [self.collectionView reloadData];
}

#pragma mark - Handing tap gesture for dismissing keyboard

- (void) dismissKeyboard
{
    //Code to handle the gesture
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *evaluatedObject, NSDictionary *bindings) {
            NSString *username = [self.dataLoader getUsername:evaluatedObject];
            return [username.lowercaseString containsString:searchText.lowercaseString];
        }];
        self.possibleFriendsFiltered = [self.possibleFriends filteredArrayUsingPredicate:predicate];
    } else {
        self.possibleFriendsFiltered = self.possibleFriends;
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.possibleFriendsFiltered.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendsCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"friendsCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 30;
    [cell setCell:self.possibleFriendsFiltered[indexPath.row]];
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
