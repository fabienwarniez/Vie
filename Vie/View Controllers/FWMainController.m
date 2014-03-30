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
@end

@implementation FWMainController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        FWGameViewController *gameViewController = [[FWGameViewController alloc] initWithSize:frame.size];
        [self addChildViewController:gameViewController];
        [gameViewController didMoveToParentViewController:self];
        _gameViewController = gameViewController;

        FWNavigationController *navigationViewController = [[FWNavigationController alloc] initWithNibName:nil bundle:nil];
        [self addChildViewController:navigationViewController];
        [navigationViewController didMoveToParentViewController:self];
        _navigationViewController = navigationViewController;
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];

    self.gameViewController.view.frame = view.frame;
    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    self.navigationViewController.view.frame = CGRectMake(- view.bounds.size.width + 10, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height);
    self.navigationViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;

    [view addSubview:self.gameViewController.view];
    [view addSubview:self.navigationViewController.view];

    self.view = view;
}

@end