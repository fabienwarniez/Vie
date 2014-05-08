//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternPickerTableViewController.h"

static NSString * const kFWCellPatternPickerViewControllerCellIdentifier = @"PatternCell";
static CGFloat const kFWCellPatternPickerViewControllerCellHeight = 100.0f;

@interface FWCellPatternPickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FWCellPatternPickerTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFWCellPatternPickerViewControllerCellIdentifier];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIT *dequeuedCell = [tableView dequeueReusableCellWithIdentifier:kFWCellPatternPickerViewControllerCellIdentifier forIndexPath:indexPath];

    if (indexPath.row == 2)
    {
        dequeuedCell.textLabel.text = NSLocalizedString(@"menu_item_save_game", nil);
        dequeuedCell.useCustomAccessoryView = YES;
        dequeuedCell.accessoryImage = [UIImage imageNamed:@"save"];
        dequeuedCell.accessoryImageFlipped = [UIImage imageNamed:@"checkmark"];
        dequeuedCell.flashColor = [UIColor successfulBackgroundColor];
        dequeuedCell.delegate = self;
    }
    else
    {
        if (indexPath.row == 0)
        {
            dequeuedCell.textLabel.text = NSLocalizedString(@"menu_item_cell_color", nil);
        }
        else if (indexPath.row == 1)
        {
            dequeuedCell.textLabel.text = NSLocalizedString(@"menu_item_board_size", nil);
        }
        else if (indexPath.row == 3)
        {
            dequeuedCell.textLabel.text = NSLocalizedString(@"menu_item_load_game", nil);
        }
        else
        {
            NSAssert(false, @"There are only 4 items in the menu");
        }

        dequeuedCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
    }

    return dequeuedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWMainMenuViewControllerCellHeight;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0)
    {
        FWColorSchemePickerTableViewController *colorSchemePickerTableViewController = [[FWColorSchemePickerTableViewController alloc] init];
        colorSchemePickerTableViewController.delegate = self.mainViewController;
        [self.navigationController pushViewController:colorSchemePickerTableViewController animated:YES];
    }
    else if (indexPath.row == 1)
    {
        FWBoardSizePickerTableViewController *boardSizePickerTableViewController = [[FWBoardSizePickerTableViewController alloc] init];
        boardSizePickerTableViewController.delegate = self.mainViewController;
        [self.navigationController pushViewController:boardSizePickerTableViewController animated:YES];
    }
    else if (indexPath.row == 3)
    {
        FWSavedGamePickerTableViewController *savedGamePickerTableViewController = [[FWSavedGamePickerTableViewController alloc] init];
        savedGamePickerTableViewController.delegate = self.mainViewController;
        [self.navigationController pushViewController:savedGamePickerTableViewController animated:YES];
    }
}

@end