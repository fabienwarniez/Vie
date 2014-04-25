//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWColorSchemeModel.h"
#import "FWColorSchemeTableViewCell.h"
#import "FWUserModel.h"

static NSString *kColorSchemeCellIdentifier = @"ColorSchemeCell";

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
        [_tableView registerNib:[UINib nibWithNibName:@"FWColorSchemeTableViewCell" bundle:nil] forCellReuseIdentifier:kColorSchemeCellIdentifier];

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
    FWColorSchemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kColorSchemeCellIdentifier forIndexPath:indexPath];
    cell.colorNameLabel.text = model.colorSchemeName;
    cell.cellPreviewFillColor = model.fillColor;
    cell.cellPreviewBorderColor = model.borderColor;
    cell.selected = [self.currentlyActiveColorScheme isEqualToColorScheme:model];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWColorSchemeModel *colorScheme = self.colors[(NSUInteger) indexPath.row];
    self.currentlyActiveColorScheme = colorScheme;
    [self.delegate colorSchemeDidChange:colorScheme];
}

@end