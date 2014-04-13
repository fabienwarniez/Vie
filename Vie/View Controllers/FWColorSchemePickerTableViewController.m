//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWColorScheme.h"
#import "FWColorSchemeTableViewCell.h"

static NSString *kColorSchemeCellIdentifier = @"ColorSchemeCell";

@interface FWColorSchemePickerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *colors;

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

        NSMutableArray *colors = [NSMutableArray array];

        NSArray *colorList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"]];
        NSAssert(colorList != nil, @"Colors.plist is corrupted.");
        for (NSDictionary *colorDictionary in colorList)
        {
            FWColorScheme *colorObject = [FWColorScheme colorSchemeWithDictionary:colorDictionary];
            NSAssert(colorObject != nil, @"Colors.plist is corrupted.");
            [colors addObject:colorObject];
        }

        _colors = [colors copy];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    self.title = @"Cell Color";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [self.colors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    FWColorScheme *model = self.colors[(NSUInteger) indexPath.row];
    FWColorSchemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kColorSchemeCellIdentifier forIndexPath:indexPath];
    cell.colorNameLabel.text = model.colorSchemeName;
    cell.cellPreviewFillColor = model.fillColor;
    cell.cellPreviewBorderColor = model.borderColor;

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
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end