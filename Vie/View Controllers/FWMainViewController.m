//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWBoardSizeModel.h"
#import "FWColorSchemeModel.h"
#import "FWSavedGameModel.h"
#import "FWPatternModel.h"
#import "FWMainMenuViewController.h"
#import "UIView+FWConvenience.h"
#import "FWQuickPlayMenuViewController.h"
#import "FWUserModel.h"
#import "FWPatternPickerViewController.h"
#import "FWDataManager.h"
#import "FWPatternManager.h"

static CGFloat const kFWGameViewControllerCellBorderWidth = 1.0f;

@interface FWMainViewController () <UINavigationBarDelegate, FWMainMenuViewControllerDelegate, FWGameViewControllerDelegate, FWQuickPlayMenuControllerDelegate, FWPatternPickerViewControllerDelegate>

@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWQuickPlayMenuViewController *quickPlayMenuController;
@property (nonatomic, strong) FWPatternPickerViewController *patternPickerViewController;
@property (nonatomic, assign) BOOL isQuickGameVisible;
@property (nonatomic, assign) BOOL isQuickGameMenuVisible;
@property (nonatomic, assign) BOOL isPatternPickerVisible;

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
        _gameViewController.boardSize = userModel.boardSize;
        _gameViewController.cellBorderWidth = kFWGameViewControllerCellBorderWidth;
        _gameViewController.cellFillColorScheme = userModel.colorScheme;
        _gameViewController.gameSpeed = userModel.gameSpeed;
        _gameViewController.delegate = self;

        _mainMenuViewController = [[FWMainMenuViewController alloc] init];
        _mainMenuViewController.delegate = self;

        _patternPickerViewController = [[FWPatternPickerViewController alloc] init];
        _patternPickerViewController.delegate = self;

        _isQuickGameVisible = NO;
        _isQuickGameMenuVisible = NO;
        _isPatternPickerVisible = NO;
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

    [self addChildViewController:self.patternPickerViewController];
    self.patternPickerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.patternPickerViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.patternPickerViewController.view];
    [self.patternPickerViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (self.isQuickGameVisible)
    {
        self.gameViewController.view.frame = self.view.bounds;
    }
    else
    {
        self.gameViewController.view.frame = [self.view frameBelow];
    }

    if (self.isQuickGameMenuVisible)
    {
        self.quickPlayMenuController.view.frame = self.view.bounds;
    }
    else
    {
        self.quickPlayMenuController.view.frame = [self.view frameBelow];
    }

    if (self.isPatternPickerVisible)
    {
        self.patternPickerViewController.view.frame = self.view.bounds;
    }
    else
    {
        self.patternPickerViewController.view.frame = [self.view frameBelow];
    }
}

#pragma mark - Private Methods

- (void)showQuickGame
{
    [self.gameViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f];
    self.isQuickGameVisible = YES;
}

- (void)hideQuickGame
{
    [self.gameViewController.view slideTo:[self.view frameBelow] duration:0.3f delay:0.0f];
    self.isQuickGameVisible = NO;
}

- (void)showQuickPlayMenu
{
    [self.quickPlayMenuController.view slideTo:self.view.bounds duration:0.3f delay:0.0f];
    self.isQuickGameMenuVisible = YES;
}

- (void)hideQuickPlayMenu
{
    [self.quickPlayMenuController.view slideTo:[self.view frameBelow] duration:0.3f delay:0.0f];
    self.isQuickGameMenuVisible = NO;
}

- (void)showPatternPicker
{
    [self.patternPickerViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f];
    self.isPatternPickerVisible = YES;
}

- (void)hidePatternPicker
{
    [self.patternPickerViewController.view slideTo:[self.view frameBelow] duration:0.3f delay:0.0f];
    self.isPatternPickerVisible = NO;
}

#pragma mark - FWMainMenuViewControllerDelegate

- (void)quickGameButtonTapped
{
    [self showQuickGame];
    // TODO: load new game
}

- (void)patternsButtonTapped
{
    [self showPatternPicker];
}

#pragma mark - FWGameViewControllerDelegate

- (void)menuButtonTappedForGameViewController:(FWGameViewController *)gameViewController
{
    if (self.quickPlayMenuController == nil)
    {
        FWQuickPlayMenuViewController *quickPlayMenuController = [[FWQuickPlayMenuViewController alloc] initWithNibName:@"FWQuickPlayMenuController" bundle:nil];
        quickPlayMenuController.delegate = self;
        [self addChildViewController:quickPlayMenuController];
        quickPlayMenuController.view.frame = [self.view frameBelow];
        [self.view addSubview:quickPlayMenuController.view];
        [quickPlayMenuController didMoveToParentViewController:self];
        self.quickPlayMenuController = quickPlayMenuController;
    }

    [self showQuickPlayMenu];
}

#pragma mark - FWQuickPlayMenuControllerDelegate

- (void)quickPlayMenuDidClose:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
{
    [self hideQuickPlayMenu];
}

- (void)quickPlayMenuDidQuit:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
{
    [self hideQuickPlayMenu];
    [self hideQuickGame];
}

- (void)quickPlayMenuDidRestart:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
{
    [self.gameViewController restart];
}

- (void)quickPlayMenuDidSave:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [dateFormatter stringFromDate:now];

    NSArray *liveCells = [self.gameViewController initialBoardLiveCells];

    FWUserModel *userModel = [FWUserModel sharedUserModel];
    [userModel saveGameWithName:dateString boardSize:self.gameViewController.boardSize liveCells:liveCells];
}

- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController colorSchemeDidChange:(FWColorSchemeModel *)colorScheme
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setColorScheme:colorScheme];

    self.gameViewController.cellFillColorScheme = colorScheme;
}

- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController boardSizeDidChange:(FWBoardSizeModel *)boardSize
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setBoardSize:boardSize];

    self.gameViewController.boardSize = boardSize;
}

- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController gameSpeedDidChange:(NSUInteger)gameSpeed
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setGameSpeed:gameSpeed];

    self.gameViewController.gameSpeed = gameSpeed;
}

#pragma mark - FWSavedGamePickerTableViewControllerDelegate

- (void)loadSavedGame:(FWSavedGameModel *)savedGame
{
//    [self.gameViewController loadSavedGame:savedGame];
//
//    [self.gameViewController setForceResumeAfterInterruption:NO];
//    [self closeMenu];
}

#pragma mark - FWPatternPickerViewControllerDelegate

- (void)patternPicker:(FWPatternPickerViewController *)patternPickerViewController didSelectCellPattern:(FWPatternModel *)cellPattern
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, cellPattern.name);

    [self.gameViewController setPattern:cellPattern];

    [self.gameViewController setForceResumeAfterInterruption:NO];

    [self hidePatternPicker];

    [self showQuickGame];
}

- (void)patternPickerDidClose:(FWPatternPickerViewController *)patternPickerViewController
{
    [self hidePatternPicker];
}

@end