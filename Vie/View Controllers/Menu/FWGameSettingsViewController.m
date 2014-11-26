//
// Created by Fabien Warniez on 14-11-23.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameSettingsViewController.h"
#import "FWColorSchemeModel.h"
#import "FWUserModel.h"
#import "UIView+FWConvenience.h"
#import "UIFont+FWAppFonts.h"
#import "UIColor+FWAppColors.h"
#import "FWTileButton.h"

static NSUInteger const kNumberOfColorColumns = 3;
static CGFloat const kFWColorCellHorizontalMargin = 50.0f;
static CGFloat const kFWColorCellTopPadding = 40.0f;
static CGFloat const kFWColorCellSpacing = 1.0f;
static CGFloat const kFWVerticalSpacing = 10.0f;

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

    CGFloat currentY = self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height + kFWColorCellTopPadding;
    currentY += [self placeLabelWithString:@"colour" at:currentY];
    currentY += kFWVerticalSpacing;
    currentY += [self setupColorCellsStartingAt:currentY];
    currentY += kFWVerticalSpacing;
    currentY += [self placeLabelWithString:@"size" at:currentY];
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

- (CGFloat)placeLabelWithString:(NSString *)string at:(CGFloat)y
{
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.text = string;
    colorLabel.font = [UIFont smallRegular];
    colorLabel.textColor = [UIColor colorWithDecimalRed:98.0f green:98.0f blue:98.0f];
    [colorLabel sizeToFit];
    colorLabel.frame = CGRectMake(
            (self.view.bounds.size.width - colorLabel.frame.size.width) / 2.0f,
            y,
            colorLabel.frame.size.width,
            colorLabel.frame.size.height
    );

    [self.view addSubview:colorLabel];

    return colorLabel.frame.size.height;
}

- (CGFloat)setupColorCellsStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWColorCellHorizontalMargin - (kNumberOfColorColumns - 1) * kFWColorCellSpacing) / kNumberOfColorColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    CGFloat totalHeight = cellSideSize;
    NSUInteger currentColumn = 0;

    for (FWColorSchemeModel *colorSchemeModel in self.colors)
    {
        FWTileButton *newTile = [FWTileButton buttonWithMainColor:colorSchemeModel.youngFillColor];
        newTile.frame = CGRectMake(
                kFWColorCellHorizontalMargin + currentColumn * (cellSideSize + kFWColorCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );
        if (currentColumn == kNumberOfColorColumns - 1)
        {
            currentY += kFWColorCellSpacing + cellSideSize;
            totalHeight += kFWColorCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }

        [self.view addSubview:newTile];
    }

    return totalHeight;
}

@end