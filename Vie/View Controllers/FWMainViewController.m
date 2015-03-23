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
#import "UIView+FWConvenience.h"
#import "FWQuickPlayMenuViewController.h"
#import "FWUserModel.h"
#import "FWPatternPickerViewController.h"
#import "FWSavedGamePickerViewController.h"
#import "FWSavedGameManager.h"
#import "FWDataManager.h"
#import "FWLaunchScreenViewController.h"
#import "FWAboutViewController.h"

static CGFloat const kFWGameViewControllerCellBorderWidth = 1.0f;

@interface FWMainViewController ()
        <FWLaunchScreenViewControllerDelegate,
        FWGameViewControllerDelegate,
        FWQuickPlayMenuControllerDelegate,
        FWPatternPickerViewControllerDelegate,
        FWSavedGamePickerViewControllerDelegate,
        FWAboutViewControllerDelegate>

@property (nonatomic, strong) FWLaunchScreenViewController *launchScreenViewController;
@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWQuickPlayMenuViewController *quickPlayMenuController;
@property (nonatomic, strong) FWPatternPickerViewController *patternPickerViewController;
@property (nonatomic, strong) FWSavedGamePickerViewController *savedGamePickerViewController;
@property (nonatomic, strong) FWAboutViewController *aboutViewController;
@property (nonatomic, assign) BOOL isQuickGameVisible;
@property (nonatomic, assign) BOOL isQuickGameMenuVisible;
@property (nonatomic, assign) BOOL isPatternPickerVisible;
@property (nonatomic, assign) BOOL isSavedGamePickerVisible;
@property (nonatomic, assign) BOOL isAboutVisible;

@end

@implementation FWMainViewController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _launchScreenViewController = [[FWLaunchScreenViewController alloc] initWithNibName:@"FWLaunchScreenViewController" bundle:nil];
        _launchScreenViewController.delegate = self;

        _isQuickGameVisible = NO;
        _isQuickGameMenuVisible = NO;
        _isPatternPickerVisible = NO;
        _isSavedGamePickerVisible = NO;
        _isAboutVisible = NO;
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

    [self addChildViewController:self.launchScreenViewController];
    self.launchScreenViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.launchScreenViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.launchScreenViewController.view];
    [self.launchScreenViewController didMoveToParentViewController:self];
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

    if (self.isSavedGamePickerVisible)
    {
        self.savedGamePickerViewController.view.frame = self.view.bounds;
    }
    else
    {
        self.savedGamePickerViewController.view.frame = [self.view frameBelow];
    }

    if (self.isAboutVisible)
    {
        self.aboutViewController.view.frame = self.view.bounds;
    }
    else
    {
        self.aboutViewController.view.frame = [self.view frameBelow];
    }
}

#pragma mark - Private Methods

- (void)showQuickGame
{
    FWUserModel *userModel = [FWUserModel sharedUserModel];
    if (self.gameViewController == nil)
    {
        FWGameViewController *gameViewController = [[FWGameViewController alloc] initWithNibName:@"FWGameViewController" bundle:nil];
        gameViewController.boardSize = userModel.boardSize; // board size must be set before the view is accessed
        gameViewController.cellBorderWidth = kFWGameViewControllerCellBorderWidth;
        gameViewController.cellFillColorScheme = userModel.colorScheme;
        gameViewController.gameSpeed = userModel.gameSpeed;
        gameViewController.delegate = self;
        gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.gameViewController = gameViewController;
    } else {
        if (![self.gameViewController.boardSize isEqualToBoardSize:userModel.boardSize]) {
            self.gameViewController.boardSize = userModel.boardSize;
        }
    }

    self.gameViewController.cellFillColorScheme = userModel.colorScheme;
    self.gameViewController.gameSpeed = userModel.gameSpeed;

    [self addChildViewController:self.gameViewController];
    self.gameViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.gameViewController.view];
    [self.gameViewController didMoveToParentViewController:self];

    [self.gameViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
    self.isQuickGameVisible = YES;
}

- (void)hideQuickGame
{
    [self.gameViewController.view slideTo:[self.view frameBelow]
                                 duration:0.3f
                                    delay:0.0f
                               completion:^(BOOL finished) {
                                   [self.gameViewController willMoveToParentViewController:nil];
                                   [self.gameViewController.view removeFromSuperview];
                                   [self.gameViewController removeFromParentViewController];
                               }];
    self.isQuickGameVisible = NO;
}

- (void)showQuickPlayMenu
{
    if (self.quickPlayMenuController == nil) {
        FWQuickPlayMenuViewController *quickPlayMenuController = [[FWQuickPlayMenuViewController alloc] initWithNibName:@"FWQuickPlayMenuController" bundle:nil];
        quickPlayMenuController.delegate = self;
        self.quickPlayMenuController = quickPlayMenuController;
    }

    [self addChildViewController:self.quickPlayMenuController];
    self.quickPlayMenuController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.quickPlayMenuController.view];
    [self.quickPlayMenuController didMoveToParentViewController:self];

    [self.quickPlayMenuController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
    self.isQuickGameMenuVisible = YES;
}

- (void)hideQuickPlayMenu
{
    [self.quickPlayMenuController.view slideTo:[self.view frameBelow]
                                 duration:0.3f
                                    delay:0.0f
                               completion:^(BOOL finished) {
                                   [self.quickPlayMenuController willMoveToParentViewController:nil];
                                   [self.quickPlayMenuController.view removeFromSuperview];
                                   [self.quickPlayMenuController removeFromParentViewController];
                               }];
    self.isQuickGameMenuVisible = NO;
}

- (void)showPatternPicker
{
    if (self.patternPickerViewController == nil) {
        FWPatternPickerViewController *patternPickerViewController = [[FWPatternPickerViewController alloc] init];
        patternPickerViewController.delegate = self;
        self.patternPickerViewController = patternPickerViewController;
    }

    FWUserModel *userModel = [FWUserModel sharedUserModel];
    self.patternPickerViewController.colorScheme = [userModel colorScheme];
    self.patternPickerViewController.boardSize = [userModel boardSize];

    [self addChildViewController:self.patternPickerViewController];
    self.patternPickerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.patternPickerViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.patternPickerViewController.view];
    [self.patternPickerViewController didMoveToParentViewController:self];

    [self.patternPickerViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
    self.isPatternPickerVisible = YES;
}

- (void)hidePatternPicker
{
    [self.patternPickerViewController.view slideTo:[self.view frameBelow]
                                          duration:0.3f
                                             delay:0.0f
                                        completion:^(BOOL finished) {
                                            [self.patternPickerViewController willMoveToParentViewController:nil];
                                            [self.patternPickerViewController.view removeFromSuperview];
                                            [self.patternPickerViewController removeFromParentViewController];
                                        }];
    self.isPatternPickerVisible = NO;
}

- (void)showSavedGamePicker
{
    if (self.savedGamePickerViewController == nil) {
        FWSavedGamePickerViewController *savedGamePickerViewController = [[FWSavedGamePickerViewController alloc] init];
        savedGamePickerViewController.delegate = self;
        self.savedGamePickerViewController = savedGamePickerViewController;
    }

    FWUserModel *userModel = [FWUserModel sharedUserModel];
    self.savedGamePickerViewController.colorScheme = [userModel colorScheme];

    [self addChildViewController:self.savedGamePickerViewController];
    self.savedGamePickerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.savedGamePickerViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.savedGamePickerViewController.view];
    [self.savedGamePickerViewController didMoveToParentViewController:self];

    [self.savedGamePickerViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
    self.isSavedGamePickerVisible = YES;
}

- (void)hideSavedGamePicker
{
    [self.savedGamePickerViewController.view slideTo:[self.view frameBelow]
                                          duration:0.3f
                                             delay:0.0f
                                        completion:^(BOOL finished) {
                                            [self.savedGamePickerViewController willMoveToParentViewController:nil];
                                            [self.savedGamePickerViewController.view removeFromSuperview];
                                            [self.savedGamePickerViewController removeFromParentViewController];
                                        }];
    self.isSavedGamePickerVisible = NO;
}

- (void)showAbout
{
    if (self.aboutViewController == nil) {
        FWAboutViewController *aboutViewController = [[FWAboutViewController alloc] init];
        aboutViewController.delegate = self;
        self.aboutViewController = aboutViewController;
    }

    [self addChildViewController:self.aboutViewController];
    self.aboutViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.aboutViewController.view.frame = [self.view frameBelow];
    [self.view addSubview:self.aboutViewController.view];
    [self.aboutViewController didMoveToParentViewController:self];

    [self.aboutViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f completion:nil];
    self.isAboutVisible = YES;
}

- (void)hideAbout
{
    [self.aboutViewController.view slideTo:[self.view frameBelow]
                                          duration:0.3f
                                             delay:0.0f
                                        completion:^(BOOL finished) {
                                            [self.aboutViewController willMoveToParentViewController:nil];
                                            [self.aboutViewController.view removeFromSuperview];
                                            [self.aboutViewController removeFromParentViewController];
                                            self.aboutViewController = nil;
                                        }];
    self.isAboutVisible = NO;
}

#pragma mark - FWMainMenuViewControllerDelegate

- (void)quickGameButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController
{
    [self showQuickGame];
    // TODO: create new game
}

- (void)patternsButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController
{
    [self showPatternPicker];
}

- (void)savedGamesButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController
{
    [self showSavedGamePicker];
}

- (void)aboutButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController
{
    [self showAbout];
}

#pragma mark - FWGameViewControllerDelegate

- (void)menuButtonTappedForGameViewController:(FWGameViewController *)gameViewController
{
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

- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController didSaveWithName:(NSString *)name
{
    NSArray *liveCells = [self.gameViewController initialBoardLiveCells];

    FWSavedGameManager *savedGameManager = [[FWDataManager sharedDataManager] savedGameManager];
    FWSavedGameModel *savedGame = [savedGameManager createSavedGameWithName:name
                                                                  boardSize:self.gameViewController.boardSize
                                                                  liveCells:liveCells
                                                               creationDate:[NSDate date]];
    [savedGame.managedObjectContext save:nil];
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

#pragma mark - FWSavedGamePickerViewControllerDelegate

- (void)savedGamePicker:(FWSavedGamePickerViewController *)savedGamePickerViewController didSelectSavedGame:(FWSavedGameModel *)savedGame
{
    [self hideSavedGamePicker];
    [self showQuickGame];
    [self.gameViewController loadSavedGame:savedGame];
    [self.gameViewController setForceResumeAfterInterruption:NO];
}

- (void)savedGamePickerDidClose:(FWSavedGamePickerViewController *)savedGamePickerViewController
{
    [self hideSavedGamePicker];
}

#pragma mark - FWPatternPickerViewControllerDelegate

- (void)patternPicker:(FWPatternPickerViewController *)patternPickerViewController didSelectCellPattern:(FWPatternModel *)cellPattern
{
    [self hidePatternPicker];
    [self showQuickGame];
    [self.gameViewController setPattern:cellPattern];
    [self.gameViewController setForceResumeAfterInterruption:NO];
}

- (void)patternPickerDidClose:(FWPatternPickerViewController *)patternPickerViewController
{
    [self hidePatternPicker];
}

#pragma mark - FWAboutViewControllerDelegate

- (void)aboutDidClose:(FWAboutViewController *)aboutViewController
{
    [self hideAbout];
}

#pragma mark - UIViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if (!self.isQuickGameVisible) {
        self.gameViewController = nil;
    }
    if (!self.isQuickGameMenuVisible) {
        self.quickPlayMenuController = nil;
    }
    if (!self.isPatternPickerVisible) {
        self.patternPickerViewController = nil;
    }
    if (!self.isSavedGamePickerVisible) {
        self.savedGamePickerViewController = nil;
    }
    if (!self.isAboutVisible) {
        self.aboutViewController = nil;
    }
}

@end
