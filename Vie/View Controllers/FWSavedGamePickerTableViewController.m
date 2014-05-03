//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGamePickerTableViewController.h"
#import "FWUserModel.h"
#import "FWSavedGame.h"
#import "FWBoardSizeModel.h"
#import "FWSavedGameTableViewCell.h"

static NSString * const kFWSavedGamePickerCellIdentifier = @"SavedGameCell";
static CGFloat const kFWSavedGamePickerCellHeight = 50.0f;

@interface FWSavedGamePickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *savedGames;

@end

@implementation FWSavedGamePickerTableViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FWSavedGameTableViewCell class] forCellReuseIdentifier:kFWSavedGamePickerCellIdentifier];

        FWUserModel *userModel = [FWUserModel sharedUserModel];
        _savedGames = [userModel savedGames];
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.savedGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWSavedGame *model = self.savedGames[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFWSavedGamePickerCellIdentifier
                                                                       forIndexPath:indexPath];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Board Size %lu x %lu", (unsigned long) model.boardSize.numberOfColumns, (unsigned long) model.boardSize.numberOfRows];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWSavedGamePickerCellHeight;
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

@end