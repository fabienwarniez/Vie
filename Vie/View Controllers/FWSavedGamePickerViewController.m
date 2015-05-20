//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGamePickerViewController.h"
#import "FWColorSchemeModel.h"
#import "UIColor+FWAppColors.h"
#import "FWTextField.h"
#import "UIScrollView+FWConvenience.h"
#import "UIFont+FWAppFonts.h"
#import "FWDataManager.h"
#import "FWSavedGameManager.h"
#import "FWSavedGameModel.h"
#import "FWSavedGameCollectionViewCell.h"
#import "UIView+FWConvenience.h"
#import "FWEditSavedGameViewController.h"

static NSString * const kFWSavedGameTileReuseIdentifier = @"SavedGameTile";
static CGFloat const kFWCollectionViewSideMargin = 26.0f;
static CGFloat const kFWSearchBarContainerTopMargin = 58.0f;
static CGFloat const kFWCellSpacing = 1.0f;

@interface FWSavedGamePickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FWSavedGameCollectionViewCellDelegate, FWEditSavedGameViewControllerDelegate>

@property (nonatomic, strong) FWEditSavedGameViewController *editSavedGameViewController;
@property (nonatomic, strong) FWSavedGameManager *savedGameManager;
@property (nonatomic, strong) NSArray *savedGames;
@property (nonatomic, assign) CGFloat lastScrollPosition;
@property (nonatomic, assign) BOOL isEditSavedGameViewControllerVisible;

@end

@implementation FWSavedGamePickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _savedGameManager = [[FWDataManager sharedDataManager] savedGameManager];
        _lastScrollPosition = 0.0f;
        _isEditSavedGameViewControllerVisible = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [self.collectionView registerClass:[FWSavedGameCollectionViewCell class] forCellWithReuseIdentifier:kFWSavedGameTileReuseIdentifier];

    self.searchBar.placeholder = NSLocalizedString(@"saved-games.search", @"Search");
    self.searchBar.rightImage = [UIImage imageNamed:@"magnifier"];

    self.noResultLabel.text = NSLocalizedString(@"saved-games.no-results", @"0 results.");
    self.noResultLabel.font = [UIFont largeCondensedRegular];
    self.noResultLabel.textColor = [UIColor darkGrey];
    self.noResultContainer.hidden = YES;

    self.lastScrollPosition = self.collectionView.contentOffset.y;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    NSUInteger numberOfColums = [FWSavedGamePickerViewController numberOfColumns];
    CGFloat side = FWRoundFloat((self.collectionView.bounds.size.width - (numberOfColums - 1) * kFWCellSpacing - 2 * kFWCollectionViewSideMargin) / numberOfColums);

    self.collectionViewLayout.itemSize = CGSizeMake(side, side);
    [self.collectionViewLayout invalidateLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.savedGames = [_savedGameManager savedGamesForSearchString:nil];
    [self.collectionView reloadData];
}

#pragma mark - Accessors

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    [self.collectionView reloadData];
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return NSLocalizedString(@"saved-games.saved-games", @"Saved Games");
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self.searchBar resignFirstResponder];
    [self.delegate savedGamePickerDidClose:self];
}

- (UIImage *)buttonImageFor:(FWTitleBar *)titleBar
{
    return [UIImage imageNamed:@"x"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSUInteger count = [self.savedGames count];
        self.noResultContainer.hidden = count > 0;
        return count;
    }
    else
    {
        NSAssert(NO, @"Only 1 section.");
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWSavedGameCollectionViewCell *dequeuedCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kFWSavedGameTileReuseIdentifier forIndexPath:indexPath];
    dequeuedCell.delegate = self;

    FWSavedGameModel *model = self.savedGames[(NSUInteger) indexPath.row];

    dequeuedCell.mainColor = [UIColor lightGrey];
    dequeuedCell.savedGame = model;

    return dequeuedCell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollStep = self.lastScrollPosition - scrollView.contentOffset.y;
    CGRect newFrame = self.searchBarContainer.frame;

    if ([scrollView isBouncingAtTop])
    {
        newFrame.origin.y = kFWSearchBarContainerTopMargin - scrollView.contentOffset.y - scrollView.contentInset.top;
    }
    else
    {
        if (scrollStep < 0) // scrolling down
        {
            newFrame.origin.y += scrollStep;
            if ([self isSearchBarHiddenTooFarUp:newFrame.origin.y])
            {
                newFrame.origin.y = [self yPositionToHideSearchBar];
            }
        }
        else // scrolling up
        {
            if (![scrollView isBouncingAtBottom])
            {
                newFrame.origin.y += scrollStep;
                if ([self isSearchBarTooFarDown:newFrame.origin.y])
                {
                    newFrame.origin.y = [self yPositionToFullyShowSearchBar];
                }
            }
        }
    }

    self.searchBarContainer.frame = newFrame;
    self.lastScrollPosition = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - FWSavedGameCollectionViewCellDelegate

- (void)playButtonTappedForSavedGameCollectionViewCell:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell
{
    [self.searchBar resignFirstResponder];

    FWSavedGameModel *selectedModel = [self savedGameModelForCell:savedGameCollectionViewCell];
    [self.delegate savedGamePicker:self didSelectSavedGame:selectedModel];

    [FWFlurry logEvent:@"play_saved_game" withParameters:@{@"name": selectedModel.name}];
}

- (void)optionsButtonTappedForSavedGameCollectionViewCell:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell
{
    [self.searchBar resignFirstResponder];

    FWSavedGameModel *selectedModel = [self savedGameModelForCell:savedGameCollectionViewCell];
    [self showEditViewForSavedGame:selectedModel];

    [FWFlurry logEvent:@"edit_saved_game" withParameters:@{@"name": selectedModel.name}];
}

- (void)savedGameCollectionViewCellDidCancel:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell
{
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForCell:savedGameCollectionViewCell];
    [self.collectionView deselectItemAtIndexPath:selectedIndexPath animated:NO];
}

#pragma mark - FWEditSavedGameViewControllerDelegate

- (void)editSavedGameDidEdit:(FWEditSavedGameViewController *)editSavedGameViewController
{
    [self.collectionView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideEditView];
    });
}

- (void)editSavedGameDidDelete:(FWEditSavedGameViewController *)editSavedGameViewController
{
    self.savedGames = [self.savedGameManager savedGamesForSearchString:self.searchBar.text];

    [self.collectionView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideEditView];
    });
}

- (void)editSavedGameDidCancel:(FWEditSavedGameViewController *)editSavedGameViewController
{
    [self hideEditView];
}

#pragma mark - Private Methods

- (void)showEditViewForSavedGame:(FWSavedGameModel *)model
{
    if (self.editSavedGameViewController == nil)
    {
        FWEditSavedGameViewController *editSavedGameViewController = [[FWEditSavedGameViewController alloc] initWithNibName:@"FWEditSavedGameViewController" bundle:nil];
        editSavedGameViewController.savedGame = model;
        editSavedGameViewController.delegate = self;
        self.editSavedGameViewController = editSavedGameViewController;
    }

    [self addChildViewController:self.editSavedGameViewController];
    self.editSavedGameViewController.view.frame = [self.view frameToTheRight];
    [self.view addSubview:self.editSavedGameViewController.view];
    [self.editSavedGameViewController didMoveToParentViewController:self];

    [self.editSavedGameViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
}

- (void)hideEditView
{
    [self.editSavedGameViewController.view slideTo:[self.view frameToTheRight]
                                         duration:0.3f
                                            delay:0.0f
                                       completion:^(BOOL finished) {
                                           [self.editSavedGameViewController willMoveToParentViewController:nil];
                                           [self.editSavedGameViewController.view removeFromSuperview];
                                           [self.editSavedGameViewController removeFromParentViewController];
                                           self.editSavedGameViewController = nil;
                                       }];
    self.isEditSavedGameViewControllerVisible = NO;
}

- (BOOL)isSearchBarHiddenTooFarUp:(CGFloat)newY
{
    return newY < kFWSearchBarContainerTopMargin - self.searchBarContainer.frame.size.height;
}

- (BOOL)isSearchBarTooFarDown:(CGFloat)newY
{
    return newY > kFWSearchBarContainerTopMargin;
}

- (CGFloat)yPositionToHideSearchBar
{
    return kFWSearchBarContainerTopMargin - self.searchBarContainer.frame.size.height;
}

- (CGFloat)yPositionToFullyShowSearchBar
{
    return kFWSearchBarContainerTopMargin;
}

- (FWSavedGameModel *)savedGameModelForCell:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:savedGameCollectionViewCell];

    FWSavedGameModel *selectedModel = self.savedGames[(NSUInteger) indexPath.row];

    return selectedModel;
}

+ (NSUInteger)numberOfColumns
{
    if ([UIScreen mainScreen].bounds.size.width > 360.0f) {
        return 3;
    } else {
        return 2;
    }
}

#pragma mark - IBActions

- (IBAction)textFieldChanged:(FWTextField *)textField
{
    self.savedGames = [self.savedGameManager savedGamesForSearchString:textField.text];

    [self.collectionView reloadData];
}

- (IBAction)hideKeyboard:(FWTextField *)textField
{
    [textField resignFirstResponder];
}

@end
