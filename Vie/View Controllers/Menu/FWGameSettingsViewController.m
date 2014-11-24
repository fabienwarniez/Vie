//
// Created by Fabien Warniez on 14-11-23.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameSettingsViewController.h"
#import "FWColorSchemeModel.h"
#import "FWUserModel.h"
#import "UIView+FWConvenience.h"

static NSUInteger const kNumberOfColorColumns = 3;
static CGFloat const kFWColorCellHorizontalMargin = 50.0f;
static CGFloat const kFWColorCellTopPadding = 40.0f;
static CGFloat const kFWColorCellHorizontalPadding = 1.0f;
static CGFloat const kFWColorCellVerticalPadding = 1.0f;

@interface FWGameSettingsViewController () <UINavigationBarDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) FWColorSchemeModel *currentlyActiveColorScheme;

@end

@implementation FWGameSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _colors = [FWColorSchemeModel colors];
        _currentlyActiveColorScheme = [[FWUserModel sharedUserModel] colorScheme];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupColorCells];
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.view slideTo:[self.parentViewController.view frameBelow] duration:0.3f delay:0.0f];
    [self.delegate gameSettingsDidClose:self];
}

#pragma mark - Private Methods

- (void)setupColorCells
{
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWColorCellHorizontalMargin - (kNumberOfColorColumns - 1) * kFWColorCellHorizontalPadding) / kNumberOfColorColumns;
    CGFloat currentY = self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height + kFWColorCellTopPadding;
    NSUInteger currentColumn = 0;

    for (FWColorSchemeModel *colorSchemeModel in self.colors)
    {
        UIView *newCell = [[UIView alloc] init];
        newCell.backgroundColor = colorSchemeModel.youngFillColor;
        newCell.frame = CGRectMake(
                kFWColorCellHorizontalMargin + currentColumn * (cellSideSize + kFWColorCellHorizontalPadding),
                currentY,
                cellSideSize,
                cellSideSize
        );
        if (currentColumn == kNumberOfColorColumns - 1)
        {
            currentY += kFWColorCellVerticalPadding + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }

        [self.view addSubview:newCell];
    }
}

@end