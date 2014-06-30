//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternPickerTableViewController.h"
#import "FWCellPatternTableViewCell.h"
#import "FWCellPatternModel.h"
#import "FWUserModel.h"
#import "FWColorSchemeModel.h"
#import "FWCellPatternLoader.h"
#import "FWBoardSizeModel.h"

static NSString * const kFWCellPatternPickerViewControllerCellIdentifier = @"PatternCell";
static CGFloat const kFWCellPatternPickerViewControllerCellHeight = 100.0f;

@interface FWCellPatternPickerTableViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *customSearchDisplayController;
@property (nonatomic, strong) FWCellPatternLoader *cellPatternLoader;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *filteredPatternsArray;

@end

@implementation FWCellPatternPickerTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellPatternLoader = [[FWCellPatternLoader alloc] init];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FWCellPatternTableViewCell class] forCellReuseIdentifier:kFWCellPatternPickerViewControllerCellIdentifier];

        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

        _customSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        _customSearchDisplayController.delegate = self;
        _customSearchDisplayController.searchResultsDelegate = self;
        _customSearchDisplayController.searchResultsDataSource = self;

        FWUserModel *userModel = [FWUserModel sharedUserModel];
        _colorScheme = [userModel colorScheme];
        _boardSize = [userModel gameBoardSize];

        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"main_menu_title", nil);
    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                            target:nil
                                            action:nil];
    self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                          target:self
                                                          action:@selector(searchButtonTapped:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.cellPatternLoader cellPatternsInRange:NSMakeRange(0, [self.cellPatternLoader numberOfPatterns])];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return [self.cellPatternLoader numberOfPatterns];
    }
    else
    {
        return [self.filteredPatternsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternTableViewCell *dequeuedCell = [self.tableView dequeueReusableCellWithIdentifier:kFWCellPatternPickerViewControllerCellIdentifier forIndexPath:indexPath];
    FWCellPatternModel *model = nil;

    if (tableView == self.tableView)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        model = modelArray[0];
    }
    else
    {
        model = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    dequeuedCell.cellPattern = model;
    dequeuedCell.colorScheme = self.colorScheme;
    dequeuedCell.fitsOnCurrentBoard = [model.boardSize isSmallerOrEqualToBoardSize:self.boardSize];

    return dequeuedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWCellPatternPickerViewControllerCellHeight;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternModel *selectedModel = nil;

    if (tableView == self.tableView)
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FWCellPatternModel *selectedModel = nil;

    if (tableView == self.tableView)
    {
        NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
        NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
        selectedModel = modelArray[0];
    }
    else
    {
        selectedModel = self.filteredPatternsArray[(NSUInteger) indexPath.row];
    }

    [self.delegate didSelectCellPattern:selectedModel];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSArray *allPatternsArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange(0, [self.cellPatternLoader numberOfPatterns])];
    self.filteredPatternsArray = [allPatternsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString]];

    return YES;
}

#pragma mark - Private methods

- (void)searchButtonTapped:(id)sender
{
    double delay = 0;

    if (self.tableView.contentInset.top != -1 * self.tableView.contentOffset.y)
    {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        delay = 0.3f;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
        [self.searchDisplayController setActive:YES animated:YES];
        [self.searchBar becomeFirstResponder];
    });
}

@end