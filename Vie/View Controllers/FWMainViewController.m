//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWMainMenuViewController.h"

static const CGFloat SWIPEABLE_AREA_WIDTH = 40.0;

@interface FWMainViewController ()

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) UINavigationController *swipeOutNavigationController;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect navigationClosedFrame;
@property (nonatomic, assign) CGRect navigationOpenFrame;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainViewController

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        _size = size;
        _isMenuExpanded = NO;
        FWGameViewController *gameViewController = [[FWGameViewController alloc] init];
        [self addChildViewController:gameViewController];
        [gameViewController didMoveToParentViewController:self];
        _gameViewController = gameViewController;

        FWMainMenuViewController *mainMenuViewController = [[FWMainMenuViewController alloc] initWithNibName:nil bundle:nil];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];

    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    self.navigationOpenFrame = self.view.bounds;
    CGRect navigationClosedFrame = self.navigationOpenFrame;
    navigationClosedFrame.origin.x -= navigationClosedFrame.size.width - SWIPEABLE_AREA_WIDTH;
    self.navigationClosedFrame = navigationClosedFrame;
    self.navigationContainerView.frame = self.navigationClosedFrame;

    CGRect swipeOutNavigationFrame = self.navigationContainerView.bounds;
    swipeOutNavigationFrame.size.width -= SWIPEABLE_AREA_WIDTH;
    self.swipeOutNavigationController.view.frame = swipeOutNavigationFrame;

    self.gameViewController.view.frame = self.view.bounds;
}

- (void)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
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

@end