//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGamePickerTableViewController.h"
#import "FWUserModel.h"
#import "FWSavedGameTableViewCell.h"
#import "FWSavedGame.h"
#import "FWBoardSizeModel.h"

static NSString * const kFWSavedGamePickerCellIdentifier = @"SavedGameCell";
static CGFloat const kFWSavedGamePickerCellHeight = 60.0f;

@interface FWSavedGamePickerTableViewController () <UITableViewDataSource, UITableViewDelegate, FWSavedGameTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *savedGames;
@property (nonatomic, strong) FWUserModel *userModel;

@end

@implementation FWSavedGamePickerTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FWSavedGameTableViewCell class] forCellReuseIdentifier:kFWSavedGamePickerCellIdentifier];

        _userModel = [FWUserModel sharedUserModel];
        _savedGames = [_userModel savedGames];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"saved_game_picker_title", nil);
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.savedGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWSavedGame *model = self.savedGames[(NSUInteger) indexPath.row];
    FWSavedGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFWSavedGamePickerCellIdentifier
                                                                       forIndexPath:indexPath];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Board Size %lu x %lu", (unsigned long) model.boardSize.numberOfColumns, (unsigned long) model.boardSize.numberOfRows];
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWSavedGamePickerCellHeight;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Delete row %u", indexPath.row);
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FWSavedGame *savedGame = self.savedGames[(NSUInteger) indexPath.row];

    [self.delegate loadSavedGame:savedGame];
}

#pragma mark - FWSavedGameTableViewCellDelegate methods

- (void)savedGameCell:(FWSavedGameTableViewCell *)savedGameCell didEditGameName:(NSString *)name
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:savedGameCell];
    FWSavedGame *savedGameToEdit = self.savedGames[(NSUInteger) indexPath.row];
    savedGameToEdit.name = name;
    [self.userModel editSavedGame:savedGameToEdit];
}

@end