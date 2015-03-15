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
#import "FWColorTile.h"
#import "FWBoardSizeModel.h"
#import "FWSizeTile.h"
#import "FWGameSpeed.h"
#import "FWSpeedTile.h"

static NSUInteger const kFWNumberOfColorColumns = 3;
static NSUInteger const kFWNumberOfSizeColumns = 2;
static NSUInteger const kFWNumberOfSpeedColumns = 3;
static CGFloat const kFWColorCellHorizontalMargin = 46.0f;
static CGFloat const kFWSizeCellHorizontalMargin = 60.0f;
static CGFloat const kFWColorCellTopPadding = 36.0f;
static CGFloat const kFWCellSpacing = 1.0f;
static CGFloat const kFWLabelBottomMargin = 22.0f;
static CGFloat const kFWVerticalSpacing = 36.0f;

@interface FWGameSettingsViewController () <FWColorTileDelegate, FWSizeTileDelegate, FWSpeedTileDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *colorTiles;
@property (nonatomic, strong) FWColorSchemeModel *currentlyActiveColorScheme;

@property (nonatomic, strong) NSArray *boardSizes;
@property (nonatomic, strong) NSArray *sizeTiles;
@property (nonatomic, strong) FWBoardSizeModel *currentlyActiveBoardSize;

@property (nonatomic, strong) NSArray *gameSpeeds;
@property (nonatomic, strong) NSArray *speedTiles;
@property (nonatomic, assign) NSUInteger currentlyActiveSpeed;

@property (nonatomic, strong) UILabel *colorLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *speedLabel;

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
        _currentlyActiveBoardSize = [[FWUserModel sharedUserModel] boardSize];
        _gameSpeeds = [FWGameSpeed gameSpeeds];
        _currentlyActiveSpeed = [[FWUserModel sharedUserModel] gameSpeed];
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
    self.speedLabel = [self placeLabelWithString:@"speed"];
    [self placeSpeedTiles];
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
    currentY += [self layoutLabel:self.speedLabel at:currentY];
    currentY += kFWLabelBottomMargin;
    currentY += [self layoutSpeedTilesStartingAt:currentY];
    currentY += kFWVerticalSpacing;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, currentY);
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Settings";
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self.delegate gameSettingsDidClose:self];
}

- (UIImage *)buttonImageFor:(FWTitleBar *)titleBar
{
    return [UIImage imageNamed:@"x"];
}

#pragma mark - FWColorTileDelegate

- (void)tileButtonWasSelected:(FWColorTile *)selectedColorTile
{
    for (FWColorTile *colorTile in self.colorTiles)
    {
        if (colorTile != selectedColorTile)
        {
            [colorTile setSelected:NO];
        }
    }

    NSUInteger index = [self.colorTiles indexOfObject:selectedColorTile];
    FWColorSchemeModel *newColorScheme = self.colors[index];
    self.currentlyActiveColorScheme = newColorScheme;
    [self.delegate gameSettings:self colorSchemeDidChange:newColorScheme];
}

#pragma mark - FWSizeTileDelegate

- (void)sizeTileWasSelected:(FWSizeTile *)selectedSizeTile
{
    for (FWSizeTile *sizeTile in self.sizeTiles)
    {
        if (sizeTile != selectedSizeTile)
        {
            [sizeTile setSelected:NO];
        }
    }

    NSUInteger index = [self.sizeTiles indexOfObject:selectedSizeTile];
    FWBoardSizeModel *newBoardSize = self.boardSizes[index];
    self.currentlyActiveBoardSize = newBoardSize;
    [self.delegate gameSettings:self boardSizeDidChange:newBoardSize];
}

#pragma mark - FWSpeedTileDelegate

- (void)speedTileWasSelected:(FWSpeedTile *)selectedSpeedTile
{
    for (FWSpeedTile *speedTile in self.speedTiles)
    {
        if (speedTile != selectedSpeedTile)
        {
            [speedTile setSelected:NO];
        }
    }

    NSUInteger index = [self.speedTiles indexOfObject:selectedSpeedTile];
    NSUInteger newGameSpeed = [self.gameSpeeds[index] unsignedIntegerValue];
    self.currentlyActiveSpeed = newGameSpeed;
    [self.delegate gameSettings:self gameSpeedDidChange:newGameSpeed];
}

#pragma mark - Private Methods

- (UILabel *)placeLabelWithString:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.font = [UIFont smallRegular];
    label.textColor = [UIColor darkGrey];

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
        FWColorTile *newTile = [FWColorTile tileWithMainColor:colorSchemeModel.youngFillColor image:[UIImage imageNamed:@"check"]];
        newTile.selected = [colorSchemeModel isEqualToColorScheme:self.currentlyActiveColorScheme];
        newTile.delegate = self;
        [self.scrollView addSubview:newTile];
        [array addObject:newTile];
    }
    
    self.colorTiles = [array copy];
}

- (CGFloat)layoutColorTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWColorCellHorizontalMargin - (kFWNumberOfColorColumns - 1) * kFWCellSpacing) / kFWNumberOfColorColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    NSUInteger currentColumn = 0;

    for (FWColorTile *tile in self.colorTiles)
    {
        tile.frame = CGRectMake(
                kFWColorCellHorizontalMargin + currentColumn * (cellSideSize + kFWCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );
        if (currentColumn == kFWNumberOfColorColumns - 1)
        {
            currentY += kFWCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }
    }

    NSUInteger numberOfRows = (self.colorTiles.count + kFWNumberOfColorColumns - 1) / kFWNumberOfColorColumns;
    return numberOfRows * cellSideSize + (numberOfRows - 1) * kFWCellSpacing;
}

- (void)placeSizeTiles
{
    NSMutableArray *array = [NSMutableArray array];

    NSUInteger index = 1;
    for (FWBoardSizeModel *boardSizeModel in self.boardSizes)
    {
        FWSizeTile *newTile = [FWSizeTile tileWithMainColor:[UIColor lightGrey]
                                                squareColor:[UIColor vieGreenDark]
                                    squareWidthAsPercentage:[FWGameSettingsViewController squarePercentageForSizeIndex:index]];
        newTile.selected = [boardSizeModel isEqualToBoardSize:self.currentlyActiveBoardSize];
        newTile.delegate = self;
        [self.scrollView addSubview:newTile];
        [array addObject:newTile];
        index++;
    }

    self.sizeTiles = [array copy];
}

- (CGFloat)layoutSizeTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWSizeCellHorizontalMargin - (kFWNumberOfSizeColumns - 1) * kFWCellSpacing) / kFWNumberOfSizeColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    NSUInteger currentColumn = 0;

    for (FWSizeTile *tile in self.sizeTiles)
    {
        tile.frame = CGRectMake(
                kFWSizeCellHorizontalMargin + currentColumn * (cellSideSize + kFWCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );

        if (currentColumn == kFWNumberOfSizeColumns - 1)
        {
            currentY += kFWCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }
    }

    NSUInteger numberOfRows = (self.sizeTiles.count + kFWNumberOfSizeColumns - 1) / kFWNumberOfSizeColumns;
    return numberOfRows * cellSideSize + (numberOfRows - 1) * kFWCellSpacing;
}

- (void)placeSpeedTiles
{
    NSMutableArray *array = [NSMutableArray array];

    NSUInteger index = 0;
    for (NSNumber *gameSpeed in self.gameSpeeds)
    {
        FWSpeedTile *newTile = [FWSpeedTile tileWithMainColor:[UIColor lightGrey] image:[FWGameSettingsViewController imageForSpeedTileIndex:index]];
        newTile.selected = [gameSpeed unsignedIntegerValue] == self.currentlyActiveSpeed;
        newTile.delegate = self;
        [self.scrollView addSubview:newTile];
        [array addObject:newTile];
        index++;
    }

    self.speedTiles = [array copy];
}

- (CGFloat)layoutSpeedTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWSizeCellHorizontalMargin - (kFWNumberOfSpeedColumns - 1) * kFWCellSpacing) / kFWNumberOfSpeedColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    NSUInteger currentColumn = 0;

    for (FWSpeedTile *tile in self.speedTiles)
    {
        tile.frame = CGRectMake(
                kFWSizeCellHorizontalMargin + currentColumn * (cellSideSize + kFWCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );

        if (currentColumn == kFWNumberOfSpeedColumns - 1)
        {
            currentY += kFWCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }
    }

    NSUInteger numberOfRows = (self.speedTiles.count + kFWNumberOfSpeedColumns - 1) / kFWNumberOfSpeedColumns;
    return numberOfRows * cellSideSize + (numberOfRows - 1) * kFWCellSpacing;
}

+ (NSUInteger)squarePercentageForSizeIndex:(NSUInteger)index
{
    NSUInteger percent = 0;

    if (index == 1)
    {
        percent = 50;
    }
    else if (index == 2)
    {
        percent = 35;
    }
    else if (index == 3)
    {
        percent = 20;
    }
    else if (index == 4)
    {
        percent = 5;
    }

    return percent;
}

+ (UIImage *)imageForSpeedTileIndex:(NSUInteger)index
{
    UIImage *image = nil;

    if (index == 0)
    {
        return [UIImage imageNamed:@"settings_slow"];
    }
    else if (index == 1)
    {
        return [UIImage imageNamed:@"settings_fast"];
    }
    else if (index == 2)
    {
        return [UIImage imageNamed:@"settings_fastest"];
    }

    return image;
}

@end