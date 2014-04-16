//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWMainMenuViewController.h"
#import "FWBoardSize.h"

static const CGFloat kSwipeableAreaWidth = 40.0;

@interface FWMainViewController ()

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) UINavigationController *swipeOutNavigationController;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect navigationContainerClosedFrame;
@property (nonatomic, assign) CGRect navigationContainerOpenFrame;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainViewController

- (id)initWithBoardSize:(FWBoardSize *)boardSize
{
    self = [super init];
    if (self)
    {
        _isMenuExpanded = NO;
        FWGameViewController *gameViewController = [[FWGameViewController alloc] initWithNibName:@"FWGameViewController" bundle:nil];
        [gameViewController setBoardSize:boardSize];
        [self addChildViewController:gameViewController];
        [gameViewController didMoveToParentViewController:self];
        _gameViewController = gameViewController;

        FWMainMenuViewController *mainMenuViewController = [[FWMainMenuViewController alloc] init];
        _mainMenuViewController = mainMenuViewController;

        UINavigationController *swipeOutNavigationController = [[UINavigationController alloc] initWithRootViewController:_mainMenuViewController];
        [self addChildViewController:swipeOutNavigationController];
        [swipeOutNavigationController didMoveToParentViewController:self];
        _swipeOutNavigationController = swipeOutNavigationController;
    }
    return self;
}

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
    [self addObserver:self forKeyPath:@"self.view.bounds" options:NSKeyValueObservingOptionNew context:nil];
    [self updateNavigationFrames];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.view.bounds"])
    {
        [self updateNavigationFrames];
    }
}

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

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.view.bounds"];
}

@end