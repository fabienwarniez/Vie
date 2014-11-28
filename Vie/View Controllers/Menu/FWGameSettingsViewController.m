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
#import "FWBoardSizeModel.h"
#import "FWSizeButton.h"

static NSUInteger const kNumberOfColorColumns = 3;
static NSUInteger const kNumberOfSizeColumns = 2;
static CGFloat const kFWColorCellHorizontalMargin = 46.0f;
static CGFloat const kFWSizeCellHorizontalMargin = 60.0f;
static CGFloat const kFWColorCellTopPadding = 36.0f;
static CGFloat const kFWColorCellSpacing = 1.0f;
static CGFloat const kFWLabelBottomMargin = 22.0f;
static CGFloat const kFWVerticalSpacing = 36.0f;

@interface FWGameSettingsViewController () <UINavigationBarDelegate, FWTileButtonDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *colorTiles;
@property (nonatomic, strong) FWColorSchemeModel *currentlyActiveColorScheme;
@property (nonatomic, strong) NSArray *boardSizes;
@property (nonatomic, strong) FWBoardSizeModel *currentlyActiveSize;

@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *sizeLabel;

@end

@implementation FWGameSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _colors = [FWColorSchemeModel colors];
        _currentlyActiveColorScheme = [[FWUserModel sharedUserModel] colorScheme];
        _boardSizes = [FWBoardSizeModel boardSizes];
        _currentlyActiveSize = [[FWUserModel sharedUserModel] boardSize];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.colorLabel = [self placeLabelWithString:@"colour"];
    [self placeColorTiles];
    self.sizeLabel = [self placeLabelWithString:@"size"];
    [self placeSizeTiles];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGFloat currentY = kFWColorCellTopPadding;
    currentY += [self layoutLabel:self.colorLabel at:currentY];
    currentY += kFWLabelBottomMargin;
    currentY += [self layoutColorTilesStartingAt:currentY];
    currentY += kFWVerticalSpacing;
    currentY += [self layoutLabel:self.sizeLabel at:currentY];
    currentY += kFWLabelBottomMargin;
    currentY += [self layoutSizeTilesStartingAt:currentY];
    currentY += kFWVerticalSpacing;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, currentY);
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - FWTileButtonDelegate

- (void)tileButtonWasSelected:(FWTileButton *)tileButton
{
    for (FWTileButton *colorTile in self.colorTiles)
    {
        if (colorTile != tileButton)
        {
            [colorTile setSelected:NO];
        }
    }

    NSUInteger index = [self.colorTiles indexOfObject:tileButton];
    FWColorSchemeModel *newColorScheme = self.colors[index];
    self.currentlyActiveColorScheme = newColorScheme;
    [self.delegate gameSettings:self colorSchemeDidChange:newColorScheme];
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.view slideTo:[self.parentViewController.view frameBelow] duration:0.3f delay:0.0f];
    [self.delegate gameSettingsDidClose:self];
}

#pragma mark - Private Methods

- (UILabel *)placeLabelWithString:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.font = [UIFont smallRegular];
    label.textColor = [UIColor colorWithDecimalRed:98.0f green:98.0f blue:98.0f];

    [self.scrollView addSubview:label];

    return label;
}

- (CGFloat)layoutLabel:(UILabel *)label at:(CGFloat)y
{
    [label sizeToFit];
    label.frame = CGRectMake(
            (self.view.bounds.size.width - label.frame.size.width) / 2.0f,
            y,
            label.frame.size.width,
            label.frame.size.height
    );

    return label.frame.size.height;
}

- (void)placeColorTiles
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (FWColorSchemeModel *colorSchemeModel in self.colors)
    {
        FWTileButton *newTile = [FWTileButton buttonWithMainColor:colorSchemeModel.youngFillColor image:[UIImage imageNamed:@"check"]];
        if (colorSchemeModel == self.currentlyActiveColorScheme)
        {
            newTile.selected = YES;
        }
        newTile.delegate = self;
        [self.scrollView addSubview:newTile];
        [array addObject:newTile];
    }
    
    self.colorTiles = [array copy];
}

- (CGFloat)layoutColorTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWColorCellHorizontalMargin - (kNumberOfColorColumns - 1) * kFWColorCellSpacing) / kNumberOfColorColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    CGFloat totalHeight = cellSideSize;
    NSUInteger currentColumn = 0;

    for (FWTileButton *tile in self.colorTiles)
    {
        tile.frame = CGRectMake(
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
    }

    return totalHeight;
}

- (void)placeSizeTiles
{
    NSMutableArray *array = [NSMutableArray array];

    for (FWBoardSizeModel *boardSizeModel in self.boardSizes)
    {
        FWSizeButton *newTile = [FWSizeButton buttonWithMainColor:[UIColor colorWithDecimalRed:235 green:238 blue:240] image:[UIImage imageNamed:@"check"]];
//        newTile.delegate = self;
        [self.scrollView addSubview:newTile];
        [array addObject:newTile];
    }

    self.boardSizes = [array copy];
}

- (CGFloat)layoutSizeTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWSizeCellHorizontalMargin - (kNumberOfSizeColumns - 1) * kFWColorCellSpacing) / kNumberOfSizeColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    CGFloat totalHeight = cellSideSize;
    NSUInteger currentColumn = 0;

    for (FWSizeButton *tile in self.boardSizes)
    {
        tile.frame = CGRectMake(
                kFWSizeCellHorizontalMargin + currentColumn * (cellSideSize + kFWColorCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );
        if (currentColumn == kNumberOfSizeColumns - 1)
        {
            currentY += kFWColorCellSpacing + cellSideSize;
            totalHeight += kFWColorCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }
    }

    return totalHeight;
}

@end