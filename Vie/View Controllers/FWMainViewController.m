//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWBoardSizeModel.h"
#import "FWColorSchemeModel.h"
#import "FWUserModel.h"
#import "FWSavedGame.h"
#import "FWCellPatternModel.h"
#import "FWMainMenuViewController.h"
#import "UIView+FWConvenience.h"

static CGFloat const kFWGameViewControllerCellBorderWidth = 1.0f;

@interface FWMainViewController () <UINavigationBarDelegate, FWMainMenuViewControllerDelegate>

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, assign) BOOL isQuickGameVisible;

@end

@implementation FWMainViewController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        FWUserModel *userModel = [FWUserModel sharedUserModel];

        _gameViewController = [[FWGameViewController alloc] initWithNibName:@"FWGameViewController" bundle:nil];
        _gameViewController.boardSize = userModel.gameBoardSize;
        _gameViewController.cellBorderWidth = kFWGameViewControllerCellBorderWidth;
        _gameViewController.cellFillColorScheme = userModel.colorScheme;

        _mainMenuViewController = [[FWMainMenuViewController alloc] init];

        _isQuickGameVisible = NO;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addChildViewController:self.mainMenuViewController];
    self.mainMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mainMenuViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.mainMenuViewController.view];
    [self.mainMenuViewController didMoveToParentViewController:self];

    [self addChildViewController:self.gameViewController];
    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gameViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.gameViewController.view];
    [self.gameViewController didMoveToParentViewController:self];

    self.mainMenuViewController.delegate = self;
}

- (void)viewWillLayoutSubviews
{
    if (self.isQuickGameVisible)
    {
        self.gameViewController.view.frame = self.view.bounds;
    }
    else
    {
        self.gameViewController.view.frame = [self.view frameBelow];
    }
}

#pragma mark - Private Methods

- (void)showQuickGame
{
    [self.gameViewController.view slideTo:self.view.bounds duration:0.5f delay:0];
    self.isQuickGameVisible = YES;
}

#pragma mark - FWMainMenuViewControllerDelegate

- (void)quickGameButtonTapped
{
    [self showQuickGame];
}

#pragma mark - FWMainMenuTableViewControllerDelegate

- (void)saveCurrentGame
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [dateFormatter stringFromDate:now];

    NSArray *liveCells = [self.gameViewController initialBoardLiveCells];

    FWUserModel *userModel = [FWUserModel sharedUserModel];
    [userModel saveGameWithName:dateString boardSize:self.gameViewController.boardSize liveCells:liveCells];
}

#pragma mark - FWColorSchemePickerTableViewControllerDelegate

- (void)colorSchemeDidChange:(FWColorSchemeModel *)newColorScheme
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setColorScheme:newColorScheme];

    self.gameViewController.cellFillColorScheme = newColorScheme;
}

#pragma mark - FWBoardSizePickerTableViewControllerDelegate

- (void)boardSizeDidChange:(FWBoardSizeModel *)newBoardSize
{
//    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
//    [sharedUserModel setGameBoardSize:newBoardSize];
//
//    self.gameViewController.boardSize = newBoardSize;
//    [self.gameViewController setForceResumeAfterInterruption:NO];
}

#pragma mark - FWSavedGamePickerTableViewControllerDelegate

- (void)loadSavedGame:(FWSavedGame *)savedGame
{
//    [self.gameViewController loadSavedGame:savedGame];
//
//    [self.gameViewController setForceResumeAfterInterruption:NO];
//    [self closeMenu];
}

#pragma mark - FWCellPatternPickerTableViewControllerDelegate

- (void)didSelectCellPattern:(FWCellPatternModel *)cellPattern
{
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, cellPattern.name);
//
//    [self.gameViewController setPattern:cellPattern];
//
//    [self.gameViewController setForceResumeAfterInterruption:NO];
//    [self closeMenu];
}

#pragma mark - UINavigationToolbarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end