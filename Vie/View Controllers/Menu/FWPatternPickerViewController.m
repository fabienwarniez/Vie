//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWPatternPickerViewController.h"
#import "FWUserModel.h"
#import "FWColorSchemeModel.h"
#import "FWCellPatternLoader.h"
#import "FWBoardSizeModel.h"
#import "FWPatternCollectionViewCell.h"
#import "FWCellPatternModel.h"
#import "UIColor+FWAppColors.h"
#import "FWTextField.h"
#import "UIScrollView+FWConvenience.h"
#import "UIFont+FWAppFonts.h"

static NSString * const kFWPatternTileReuseIdentifier = @"PatternTile";
static CGFloat const kFWCollectionViewSideMargin = 26.0f;
static CGFloat const kFWSearchBarContainerTopMargin = 58.0f;
static CGFloat const kFWCellSpacing = 1.0f;

@interface FWPatternPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FWCellPatternLoader *cellPatternLoader;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *filteredPatternsArray;
@property (nonatomic, assign) CGFloat lastScrollPosition;
@property (nonatomic, assign) BOOL areResultsFiltered;

@end

@implementation FWPatternPickerViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellPatternLoader = [[FWCellPatternLoader alloc] init];

        FWUserModel *userModel = [FWUserModel sharedUserModel];
        _colorScheme = [userModel colorScheme];
        _boardSize = [userModel boardSize];
        _lastScrollPosition = 0.0f;
        _areResultsFiltered = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"main_menu_title", nil);

    [self.collectionView registerClass:[FWPatternCollectionViewCell class] forCellWithReuseIdentifier:kFWPatternTileReuseIdentifier];

    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];

    self.searchBar.placeholder = @"Search";

    self.noResultLabel.text = @"0 results.";
    self.noResultLabel.font = [UIFont largeCondensedRegular];
    self.noResultLabel.textColor = [UIColor darkGrey];
    self.noResultContainer.hidden = YES;

    self.lastScrollPosition = self.collectionView.contentOffset.y;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGFloat side = (self.collectionView.bounds.size.width - kFWCellSpacing - 2 * kFWCollectionViewSideMargin) / 2.0f;

    self.collectionViewLayout.itemSize = CGSizeMake(side, side + [FWPatternCollectionViewCell titleBarHeight]);
    [self.collectionViewLayout invalidateLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.cellPatternLoader cellPatternsInRange:NSMakeRange(0, [self.cellPatternLoader numberOfPatterns])];
    });
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Patterns";
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self.searchBar resignFirstResponder];
    [self.delegate patternPickerDidClose:self];
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
        NSUInteger count;
        if (!self.areResultsFiltered)
        {
            count = [self.cellPatternLoader numberOfPatterns];
        }
        else
        {
            count = [self.filteredPatternsArray count];
        }
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
    FWPatternCollectionViewCell *dequeuedCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kFWPatternTileReuseIdentifier forIndexPath:indexPath];
    FWCellPatternModel *model = nil;

    if (!self.areResultsFiltered)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        model = modelArray[0];
    }
    else
    {
        model = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    dequeuedCell.mainColor = [UIColor lightGrey];
    dequeuedCell.cellPattern = model;
    dequeuedCell.colorScheme = self.colorScheme;
    dequeuedCell.fitsOnCurrentBoard = [model.boardSize isSmallerOrEqualToBoardSize:self.boardSize];

    return dequeuedCell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternModel *selectedModel = nil;

    if (!self.areResultsFiltered)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        selectedModel = modelArray[0];
    }
    else
    {
        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    return [selectedModel.boardSize isSmallerOrEqualToBoardSize:self.boardSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternModel *selectedModel = nil;

    if (!self.areResultsFiltered)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        selectedModel = modelArray[0];
    }
    else
    {
        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    [self.searchBar resignFirstResponder];
    [self.delegate patternPicker:self didSelectCellPattern:selectedModel];
}

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

#pragma mark - Private Methods

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

#pragma mark - IBActions

- (IBAction)textFieldChanged:(FWTextField *)textField
{
    self.areResultsFiltered = textField.text.length > 0;

    if (self.areResultsFiltered)
    {
        NSArray *allPatternsArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange(0, [self.cellPatternLoader numberOfPatterns])];
        self.filteredPatternsArray = [allPatternsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", textField.text]];
    }
    else
    {
        self.filteredPatternsArray = nil;
    }

    [self.collectionView reloadData];
}

- (IBAction)hideKeyboard:(FWTextField *)textField
{
    [textField resignFirstResponder];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.tableView)
//    {
//        return [self.cellPatternLoader numberOfPatterns];
//    }
//    else
//    {
//        return [self.filteredPatternsArray count];
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FWCellPatternTableViewCell *dequeuedCell = [self.tableView dequeueReusableCellWithIdentifier:kFWPatternTileReuseIdentifier forIndexPath:indexPath];
//    FWCellPatternModel *model = nil;
//
//    if (tableView == self.tableView)
//    {
//        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
//        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
//        model = modelArray[0];
//    }
//    else
//    {
//        model = self.filteredPatternsArray[(NSUInteger) indexPath.row];
//    }
//
//    dequeuedCell.cellPattern = model;
//    dequeuedCell.colorScheme = self.colorScheme;
//    dequeuedCell.fitsOnCurrentBoard = [model.boardSize isSmallerOrEqualToBoardSize:self.boardSize];
//
//    return dequeuedCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return kFWCellPatternPickerViewControllerCellHeight;
//}

#pragma mark - UITableViewDelegate

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    FWCellPatternModel *selectedModel = nil;
//
//    if (tableView == self.tableView)
//    {
//        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
//        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
//        selectedModel = modelArray[0];
//    }
//    else
//    {
//        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
//    }
//
//    return [selectedModel.boardSize isSmallerOrEqualToBoardSize:self.boardSize];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    FWCellPatternModel *selectedModel = nil;
//
//    if (tableView == self.tableView)
//    {
//        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
//        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
//        selectedModel = modelArray[0];
//    }
//    else
//    {
//        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
//    }
//
//    [self.delegate didSelectCellPattern:selectedModel];
//}
//
//#pragma mark - UISearchDisplayDelegate
//
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    NSArray *allPatternsArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange(0, [self.cellPatternLoader numberOfPatterns])];
//    self.filteredPatternsArray = [allPatternsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString]];
//
//    return YES;
//}

@end