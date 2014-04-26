//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWColorSchemeModel.h"
#import "FWColorSchemeTableViewCell.h"
#import "FWUserModel.h"

static NSString * const kFWColorSchemePickerCellIdentifier = @"ColorSchemeCell";
static CGFloat const kFWColorSchemePickerCellHeight = 50.0f;

@interface FWColorSchemePickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) FWColorSchemeModel *currentlyActiveColorScheme;

@end

@implementation FWColorSchemePickerTableViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"FWColorSchemeTableViewCell" bundle:nil] forCellReuseIdentifier:kFWColorSchemePickerCellIdentifier];

        _colors = [FWColorSchemeModel colorSchemesFromFile];
        _currentlyActiveColorScheme = [[FWUserModel sharedUserModel] colorScheme];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    self.title = NSLocalizedString(@"cell_color_title", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWColorSchemeModel *model = self.colors[(NSUInteger) indexPath.row];
    FWColorSchemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFWColorSchemePickerCellIdentifier forIndexPath:indexPath];
    cell.colorNameLabel.text = model.colorSchemeName;
    cell.cellPreviewFillColor = model.fillColor;
    cell.cellPreviewBorderColor = model.borderColor;
    cell.selected = [self.currentlyActiveColorScheme isEqualToColorScheme:model];
    if ([model isEqualToColorScheme:self.currentlyActiveColorScheme])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWColorSchemePickerCellHeight;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSUInteger oldColorSchemeIndex = [self.colors indexOfObject:self.currentlyActiveColorScheme];
    UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldColorSchemeIndex inSection:0]];
    previouslySelectedCell.accessoryType = UITableViewCellAccessoryNone;

    FWColorSchemeModel *colorScheme = self.colors[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    self.currentlyActiveColorScheme = colorScheme;
    [self.delegate colorSchemeDidChange:colorScheme];
}

@end