//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWMainMenuViewController.h"
#import "FWBoardSizeModel.h"
#import "FWColorSchemeModel.h"
#import "FWAppDelegate.h"
#import "FWUserModel.h"
#import "FWSettingsManager.h"

static const CGFloat kSwipeableAreaWidth = 40.0;

@interface FWMainViewController ()

@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) UINavigationController *swipeOutNavigationController;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect navigationContainerClosedFrame;
@property (nonatomic, assign) CGRect navigationContainerOpenFrame;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _isMenuExpanded = NO;

        FWUserModel *userModel = [FWUserModel sharedUserModel];

        FWGameViewController *gameViewController = [[FWGameViewController alloc] initWithNibName:@"FWGameViewController" bundle:nil];
        gameViewController.boardSize = userModel.gameBoardSize;
        gameViewController.cellBorderWidth = 1.0f;
        gameViewController.cellBorderColor = userModel.colorScheme.borderColor;
        gameViewController.cellFillColor = userModel.colorScheme.fillColor;

        [self addChildViewController:gameViewController];
        [gameViewController didMoveToParentViewController:self];
        _gameViewController = gameViewController;

        FWMainMenuViewController *mainMenuViewController = [[FWMainMenuViewController alloc] init];
        mainMenuViewController.mainViewController = self;
        _mainMenuViewController = mainMenuViewController;

        UINavigationController *swipeOutNavigationController = [[UINavigationController alloc] initWithRootViewController:_mainMenuViewController];
        [self addChildViewController:swipeOutNavigationController];
        [swipeOutNavigationController didMoveToParentViewController:self];
        _swipeOutNavigationController = swipeOutNavigationController;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    // set arbitrary frame
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    [view addSubview:self.gameViewController.view];

    self.navigationContainerView = [[UIView alloc] init];
    self.navigationContainerView.clipsToBounds = NO; // reactive area is smaller than display area
    [view addSubview:self.navigationContainerView];

    [self.navigationContainerView addSubview:self.swipeOutNavigationController.view];

    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.navigationContainerView addGestureRecognizer:rightSwipeGestureRecognizer];
    [self.navigationContainerView addGestureRecognizer:leftSwipeGestureRecognizer];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateNavigationFrames];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self updateNavigationFrames];
}

#pragma mark - Private Methods

- (void)updateNavigationFrames
{
    self.navigationContainerOpenFrame = self.view.bounds;

    CGRect navigationContainerClosedFrame = self.view.bounds;
    navigationContainerClosedFrame.origin.x -= navigationContainerClosedFrame.size.width - kSwipeableAreaWidth;
    navigationContainerClosedFrame.size.height -= self.gameViewController.toolbar.frame.size.height;
    self.navigationContainerClosedFrame = navigationContainerClosedFrame;

    CGRect swipeOutNavigationFrame = self.navigationContainerView.bounds;
    swipeOutNavigationFrame.size.width -= kSwipeableAreaWidth;
    swipeOutNavigationFrame.size.height += self.gameViewController.toolbar.frame.size.height;
    self.swipeOutNavigationController.view.frame = swipeOutNavigationFrame;

    self.gameViewController.view.frame = self.view.bounds;

    if (self.isMenuExpanded)
    {
        self.navigationContainerView.frame = self.navigationContainerOpenFrame;
    }
    else
    {
        self.navigationContainerView.frame = self.navigationContainerClosedFrame;
    }
}

- (void)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.gameViewController interruptGame];

        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.navigationContainerView.frame = self.navigationContainerOpenFrame;
                         }
                         completion:nil];

        self.isMenuExpanded = YES;
    }
    else if (self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.navigationContainerView.frame = self.navigationContainerClosedFrame;
                         }
                         completion:nil];

        self.isMenuExpanded = NO;
        [self.gameViewController resumeAfterInterruption];
    }
}

#pragma mark - FWColorSchemePickerTableViewControllerDelegate

- (void)colorSchemeDidChange:(FWColorSchemeModel *)newColorScheme
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setColorScheme:newColorScheme];

    self.gameViewController.cellBorderColor = newColorScheme.borderColor;
    self.gameViewController.cellFillColor = newColorScheme.fillColor;
}

#pragma mark - FWBoardSizePickerTableViewControllerDelegate

- (void)boardSizeDidChange:(FWBoardSizeModel *)newBoardSize
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setGameBoardSize:newBoardSize];

    self.gameViewController.boardSize = newBoardSize;
    [self.gameViewController setForceResumeAfterInterruption:NO];
}

@end