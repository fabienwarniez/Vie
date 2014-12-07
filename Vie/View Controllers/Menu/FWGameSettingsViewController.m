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

static NSUInteger const kNumberOfColorColumns = 3;
static NSUInteger const kNumberOfSizeColumns = 2;
static CGFloat const kFWColorCellHorizontalMargin = 46.0f;
static CGFloat const kFWSizeCellHorizontalMargin = 60.0f;
static CGFloat const kFWColorCellTopPadding = 36.0f;
static CGFloat const kFWColorCellSpacing = 1.0f;
static CGFloat const kFWLabelBottomMargin = 22.0f;
static CGFloat const kFWVerticalSpacing = 36.0f;

@interface FWGameSettingsViewController () <UINavigationBarDelegate, FWColorTileDelegate, FWSizeTileDelegate>

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *colorTiles;
@property (nonatomic, strong) FWColorSchemeModel *currentlyActiveColorScheme;
@property (nonatomic, strong) NSArray *boardSizes;
@property (nonatomic, strong) NSArray *sizeTiles;
@property (nonatomic, strong) FWBoardSizeModel *currentlyActiveBoardSize;

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
        _currentlyActiveBoardSize = [[FWUserModel sharedUserModel] boardSize];
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
        FWColorTile *newTile = [FWColorTile buttonWithMainColor:colorSchemeModel.youngFillColor image:[UIImage imageNamed:@"check"]];
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
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWColorCellHorizontalMargin - (kNumberOfColorColumns - 1) * kFWColorCellSpacing) / kNumberOfColorColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    CGFloat totalHeight = cellSideSize;
    NSUInteger currentColumn = 0;

    for (FWColorTile *tile in self.colorTiles)
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

    NSUInteger index = 1;
    for (FWBoardSizeModel *boardSizeModel in self.boardSizes)
    {
        FWSizeTile *newTile = [FWSizeTile buttonWithMainColor:[UIColor lightGrey]
                                                  squareColor:[UIColor vieGreenDark]
                                      squareWidthAsPercentage:[FWSizeTile squarePercentageForSizeIndex:index]];
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
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWSizeCellHorizontalMargin - (kNumberOfSizeColumns - 1) * kFWColorCellSpacing) / kNumberOfSizeColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    CGFloat totalHeight = cellSideSize;
    NSUInteger currentColumn = 0;

    for (FWSizeTile *tile in self.sizeTiles)
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