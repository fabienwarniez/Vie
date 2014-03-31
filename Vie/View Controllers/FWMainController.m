//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainController.h"
#import "FWGameViewController.h"
#import "FWNavigationController.h"

@interface FWMainController ()

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, strong) FWNavigationController *navigationViewController;
@property (nonatomic, strong) UIView *navigationContainerView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect navigationClosedFrame;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainController

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

        FWNavigationController *navigationViewController = [[FWNavigationController alloc] initWithNibName:@"FWNavigationController" bundle:nil];
        [self addChildViewController:navigationViewController];
        [navigationViewController didMoveToParentViewController:self];
        _navigationViewController = navigationViewController;
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
    self.navigationViewController.view.frame = CGRectMake(0, 0, self.navigationContainerView.frame.size.width - 40, self.navigationContainerView.frame.size.height);
    self.navigationViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.navigationContainerView addSubview:self.navigationViewController.view];

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

//- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if (self.gameViewController.isRunning)
//    {
//        [self.gameViewController pause];
//    }
//    UIView *view = panGestureRecognizer.view;
//    CGPoint translation = [panGestureRecognizer translationInView:view];
//    panGestureRecognizer.view.center = CGPointMake(view.center.x + translation.x, view.center.y);
//    [panGestureRecognizer setTranslation:CGPointZero inView:view];
//}

@end