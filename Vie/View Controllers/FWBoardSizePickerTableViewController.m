//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardSizePickerTableViewController.h"
#import "FWBoardSizeModel.h"
#import "FWUserModel.h"

static NSString * const kFWBoardSizePickerCellIdentifier = @"BoardSizeCell";
static CGFloat const kFWBoardSizePickerCellHeight = 50.0f;

@interface FWBoardSizePickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *boardSizes;
@property (nonatomic, strong) FWBoardSizeModel *currentlyActiveBoardSize;

@end

@implementation FWBoardSizePickerTableViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFWBoardSizePickerCellIdentifier];

        _boardSizes = [FWBoardSizeModel boardSizes];
        _currentlyActiveBoardSize = [[FWUserModel sharedUserModel] gameBoardSize];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"board_size_title", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.boardSizes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWBoardSizeModel *model = self.boardSizes[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFWBoardSizePickerCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%u x %u", model.numberOfColumns, model.numberOfRows];
    cell.selected = [self.currentlyActiveBoardSize isEqualToBoardSize:model];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWBoardSizePickerCellHeight;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWBoardSizeModel *boardSizeModel = self.boardSizes[(NSUInteger) indexPath.row];
    self.currentlyActiveBoardSize = boardSizeModel;
    [self.delegate boardSizeDidChange:boardSizeModel];
}

@end