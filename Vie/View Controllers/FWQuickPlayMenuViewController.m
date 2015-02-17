//
// Created by Fabien Warniez on 2014-09-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWQuickPlayMenuViewController.h"
#import "UIView+FWConvenience.h"
#import "FWGameSettingsViewController.h"
#import "FWColorSchemeModel.h"
#import "FWBoardSizeModel.h"
#import "FWMenuTile.h"
#import "UIColor+FWAppColors.h"

static NSUInteger const kFWNumberOfSettingsColumns = 2;
static CGFloat const kFWSettingsCellHorizontalMargin = 27.0f;
static CGFloat const kFWSettingsCellTopPadding = 36.0f;
static CGFloat const kFWSettingsCellSpacing = 1.0f;

@interface FWQuickPlayMenuViewController () <UINavigationBarDelegate, FWGameSettingsViewControllerDelegate, FWMenuTileDelegate>

@property (nonatomic, strong) FWGameSettingsViewController *gameSettingsViewController;

@property (nonatomic, strong) FWMenuTile *saveTile;
@property (nonatomic, strong) FWMenuTile *createGameTile;
@property (nonatomic, strong) FWMenuTile *settingsTile;
@property (nonatomic, strong) FWMenuTile *quitTile;

@property (nonatomic, assign) BOOL areGameSettingsVisible;

@end

@implementation FWQuickPlayMenuViewController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _areGameSettingsVisible = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.saveTile = [FWMenuTile tileWithMainColor:[UIColor lightGrey] image:[UIImage imageNamed:@"save"] title:@"save" subTitle:nil];
    self.createGameTile = [FWMenuTile tileWithMainColor:[UIColor lightGrey] image:[UIImage imageNamed:@"restart"] title:@"restart" subTitle:nil];
    self.settingsTile = [FWMenuTile tileWithMainColor:[UIColor lightGrey] image:[UIImage imageNamed:@"settings"] title:@"settings" subTitle:nil];
    self.quitTile = [FWMenuTile tileWithMainColor:[UIColor lightGrey] image:[UIImage imageNamed:@"quit"] title:@"quit" subTitle:@"to main menu"];

    self.saveTile.delegate = self;
    self.createGameTile.delegate = self;
    self.settingsTile.delegate = self;
    self.quitTile.delegate = self;

    [self.contentView addSubview:self.saveTile];
    [self.contentView addSubview:self.createGameTile];
    [self.contentView addSubview:self.settingsTile];
    [self.contentView addSubview:self.quitTile];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self layoutSizeTilesStartingAt:kFWSettingsCellTopPadding];
}


#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Menu";
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self close];
}

#pragma mark - FWGameSettingsViewControllerDelegate

- (void)gameSettingsDidClose:(FWGameSettingsViewController *)gameSettingsViewController
{
    [self.gameSettingsViewController.view slideTo:[self.view frameBelow] duration:0.3f delay:0.0f];
    self.areGameSettingsVisible = NO;
}

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController colorSchemeDidChange:(FWColorSchemeModel *)colorScheme
{
    [self.delegate quickPlayMenu:self colorSchemeDidChange:colorScheme];
}

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController boardSizeDidChange:(FWBoardSizeModel *)boardSize
{
    [self.delegate quickPlayMenu:self boardSizeDidChange:boardSize];
}

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController gameSpeedDidChange:(NSUInteger)gameSpeed
{
    [self.delegate quickPlayMenu:self gameSpeedDidChange:gameSpeed];
}

#pragma mark - FWMenuTileDelegate

- (void)tileButtonWasSelected:(FWMenuTile *)tileButton
{
    if (tileButton == self.saveTile)
    {
        [self.delegate quickPlayMenuDidSave:self];
    }
    else if (tileButton == self.createGameTile)
    {
        [self.delegate quickPlayMenuDidRestart:self];
        [self close];
    }
    else if (tileButton == self.settingsTile)
    {
        if (self.gameSettingsViewController == nil)
        {
            FWGameSettingsViewController *gameSettingsViewController = [[FWGameSettingsViewController alloc] initWithNibName:@"FWGameSettingsViewController" bundle:nil];
            gameSettingsViewController.delegate = self;
            [self addChildViewController:gameSettingsViewController];
            gameSettingsViewController.view.frame = [self.view frameBelow];
            [self.view addSubview:gameSettingsViewController.view];
            [gameSettingsViewController didMoveToParentViewController:self];
            self.gameSettingsViewController = gameSettingsViewController;
        }
        else
        {
            [self addChildViewController:self.gameSettingsViewController];
            self.gameSettingsViewController.view.frame = [self.view frameBelow];
            [self.view addSubview:self.gameSettingsViewController.view];
            [self.gameSettingsViewController didMoveToParentViewController:self];
        }
        [self.gameSettingsViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f];
    }
    else if (tileButton == self.quitTile)
    {
        [self.delegate quickPlayMenuDidQuit:self];
    }
    else
    {
        NSAssert(NO, @"Unrecognized tile.");
    }
}

#pragma mark - Private Methods

- (void)close
{
    [self.delegate quickPlayMenuDidClose:self];
}

- (CGFloat)layoutSizeTilesStartingAt:(CGFloat)y
{
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideSize = (self.view.bounds.size.width - 2 * kFWSettingsCellHorizontalMargin - (kFWNumberOfSettingsColumns - 1) * kFWSettingsCellSpacing) / kFWNumberOfSettingsColumns;
    cellSideSize = floorf(pixelScale * cellSideSize) / pixelScale;
    CGFloat currentY = y;
    NSUInteger currentColumn = 0;

    NSArray *tiles = @[self.saveTile, self.createGameTile, self.settingsTile, self.quitTile];

    for (FWMenuTile *tile in tiles)
    {
        tile.frame = CGRectMake(
                kFWSettingsCellHorizontalMargin + currentColumn * (cellSideSize + kFWSettingsCellSpacing),
                currentY,
                cellSideSize,
                cellSideSize
        );

        if (currentColumn == kFWNumberOfSettingsColumns - 1)
        {
            currentY += kFWSettingsCellSpacing + cellSideSize;
            currentColumn = 0;
        }
        else
        {
            currentColumn++;
        }
    }

    NSUInteger numberOfRows = (tiles.count + kFWNumberOfSettingsColumns - 1) / kFWNumberOfSettingsColumns;
    return numberOfRows * cellSideSize + (numberOfRows - 1) * kFWSettingsCellSpacing;
}

@end