//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternPickerTableViewController.h"
#import "FWCellPatternTableViewCell.h"
#import "FWCellPatternModel.h"
#import "FWUserModel.h"
#import "FWColorSchemeModel.h"

static NSString * const kFWCellPatternPickerViewControllerCellIdentifier = @"PatternCell";
static CGFloat const kFWCellPatternPickerViewControllerCellHeight = 100.0f;

@interface FWCellPatternPickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellPatterns;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;

@end

@implementation FWCellPatternPickerTableViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _cellPatterns = [FWCellPatternModel cellPatternsFromFile];

        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[FWCellPatternTableViewCell class] forCellReuseIdentifier:kFWCellPatternPickerViewControllerCellIdentifier];

        FWColorSchemeModel *colorScheme = [[FWUserModel sharedUserModel] colorScheme];
        _colorScheme = colorScheme;
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
    return [self.cellPatterns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCellPatternTableViewCell *dequeuedCell = [tableView dequeueReusableCellWithIdentifier:kFWCellPatternPickerViewControllerCellIdentifier forIndexPath:indexPath];

    FWCellPatternModel *model = self.cellPatterns[(NSUInteger) indexPath.row];
    dequeuedCell.cellPattern = model;
    dequeuedCell.colorScheme = self.colorScheme;

    return dequeuedCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kFWCellPatternPickerViewControllerCellHeight;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FWCellPatternModel *selectedModel = self.cellPatterns[(NSUInteger) indexPath.row];
    [self.delegate didSelectCellPattern:selectedModel];
}

@end