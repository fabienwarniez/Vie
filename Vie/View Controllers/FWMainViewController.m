//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWMainMenuViewController.h"

@interface FWMainViewController ()

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) UINavigationController *swipeOutNavigationController;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect navigationClosedFrame;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _frame = frame;
        _isMenuExpanded = NO;
        FWGameViewController *gameViewController = [[FWGameViewController alloc] initWithSize:frame.size];
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
    UIView *view = [[UIView alloc] initWithFrame:self.frame];

    self.gameViewController.view.frame = view.bounds;
    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view addSubview:self.gameViewController.view];

    self.navigationClosedFrame = CGRectMake(- view.bounds.size.width + 40, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);

    self.navigationContainerView = [[UIView alloc] initWithFrame:self.navigationClosedFrame];
    [view addSubview:self.navigationContainerView];

    self.swipeOutNavigationController.view.frame = CGRectMake(0, 0, self.navigationContainerView.frame.size.width - 40, self.navigationContainerView.frame.size.height);
    self.swipeOutNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.navigationContainerView addSubview:self.swipeOutNavigationController.view];

    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.navigationContainerView addGestureRecognizer:rightSwipeGestureRecognizer];
    [self.navigationContainerView addGestureRecognizer:leftSwipeGestureRecognizer];

    self.view = view;
}

- (void)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.navigationContainerView.frame = self.view.bounds;
                         }
                         completion:nil];
        self.isMenuExpanded = YES;
    }
    else if (self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [UIView animateWithDuration:0.4
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