//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWMainMenuViewController.h"
#import "FWBoardSize.h"

static const CGFloat SWIPEABLE_AREA_WIDTH = 40.0;

@interface FWMainViewController ()

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) UINavigationController *swipeOutNavigationController;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect navigationClosedFrame;
@property (nonatomic, assign) CGRect navigationOpenFrame;
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

    self.navigationOpenFrame = self.view.bounds;
    CGRect navigationClosedFrame = self.navigationOpenFrame;
    navigationClosedFrame.origin.x -= navigationClosedFrame.size.width - SWIPEABLE_AREA_WIDTH;
    self.navigationClosedFrame = navigationClosedFrame;
    self.navigationContainerView.frame = self.navigationClosedFrame;
    self.navigationContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    CGRect swipeOutNavigationFrame = self.navigationContainerView.bounds;
    swipeOutNavigationFrame.size.width -= SWIPEABLE_AREA_WIDTH;
    self.swipeOutNavigationController.view.frame = swipeOutNavigationFrame;
    self.swipeOutNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.gameViewController.view.frame = self.view.bounds;
    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    self.navigationOpenFrame = self.view.bounds;
    CGRect navigationClosedFrame = self.navigationOpenFrame;
    navigationClosedFrame.origin.x -= navigationClosedFrame.size.width - SWIPEABLE_AREA_WIDTH;
    self.navigationClosedFrame = navigationClosedFrame;

    if (!self.isMenuExpanded)
    {
        self.navigationContainerView.frame = self.navigationClosedFrame;
    }

    CGRect swipeOutNavigationFrame = self.navigationContainerView.bounds;
    swipeOutNavigationFrame.size.width -= SWIPEABLE_AREA_WIDTH;
    self.swipeOutNavigationController.view.frame = swipeOutNavigationFrame;
}

- (void)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self.gameViewController pause];

        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.navigationContainerView.frame = self.navigationOpenFrame;
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
                             self.navigationContainerView.frame = self.navigationClosedFrame;
                         }
                         completion:nil];
        self.isMenuExpanded = NO;
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"self.view.bounds"];
}

@end