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

static NSString * const kFWPatternTileReuseIdentifier = @"PatternTile";
static CGFloat const kFWCollectionViewSideMargin = 26.0f;
static CGFloat const kFWCollectionViewTopMargin = 22.0f;
static CGFloat const kFWCellSpacing = 1.0f;

@interface FWPatternPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) FWCellPatternLoader *cellPatternLoader;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *filteredPatternsArray;

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
        if (collectionView == self.collectionView)
        {
            return [self.cellPatternLoader numberOfPatterns];
        }
        else
        {
            return [self.filteredPatternsArray count];
        }
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

    if (collectionView == self.collectionView)
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

    if (collectionView == self.collectionView)
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

    if (collectionView == self.collectionView)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        selectedModel = modelArray[0];
    }
    else
    {
        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    [self.delegate patternPicker:self didSelectCellPattern:selectedModel];
}

#pragma mark - UITableViewDataSource

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