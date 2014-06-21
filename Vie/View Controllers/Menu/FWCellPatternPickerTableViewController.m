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

@interface FWCellPatternPickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FWCellPatternLoader *cellPatternLoader;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;

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

        FWUserModel *userModel = [FWUserModel sharedUserModel];
        _colorScheme = [userModel colorScheme];
        _boardSize = [userModel gameBoardSize];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    self.tableView.frame = self.view.bounds;
    self.title = NSLocalizedString(@"main_menu_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellPatternLoader numberOfPatterns];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternTableViewCell *dequeuedCell = [tableView dequeueReusableCellWithIdentifier:kFWCellPatternPickerViewControllerCellIdentifier forIndexPath:indexPath];

    NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
    NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
    FWCellPatternModel *model = modelArray[0];
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
    NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
    NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
    FWCellPatternModel *selectedModel = modelArray[0];
    return [selectedModel.boardSize isSmallerOrEqualToBoardSize:self.boardSize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *modelArray = [self.cellPatternLoader cellPatternsInRange:NSMakeRange((NSUInteger) indexPath.row, 1)];
    NSAssert([modelArray count] == 1, @"Array should contain exactly 1 object.");
    FWCellPatternModel *selectedModel = modelArray[0];
    [self.delegate didSelectCellPattern:selectedModel];
}

@end