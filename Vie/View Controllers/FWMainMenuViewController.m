//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainMenuViewController.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"
#import "UIView+FWConvenience.h"

@interface FWMainMenuViewController ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *quickPlayButton;
@property (nonatomic, strong) UIButton *patternsButton;
@property (nonatomic, strong) UIButton *savedGamesButton;
@property (nonatomic, assign) BOOL areFirstLoadAnimationsExecuted;

@end

@implementation FWMainMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _areFirstLoadAnimationsExecuted = NO;
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    view.backgroundColor = [UIColor appPrimaryVibrantColor];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.autoresizingMask =
            UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleLeftMargin;
    self.logoImageView = logoImageView;

    self.quickPlayButton = [FWMainMenuViewController createMenuButtonWithTitle:@"quick play"];
    self.patternsButton = [FWMainMenuViewController createMenuButtonWithTitle:@"patterns"];
    self.savedGamesButton = [FWMainMenuViewController createMenuButtonWithTitle:@"saved games"];

    [view addSubview:logoImageView];
    [view addSubview:self.quickPlayButton];
    [view addSubview:self.patternsButton];
    [view addSubview:self.savedGamesButton];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.logoImageView.center = CGPointMake(self.view.bounds.size.width / 2.0f, 200.0f);

    [self.quickPlayButton addTarget:self action:@selector(quickGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [UIView distributeVerticallyViews:@[self.quickPlayButton, self.patternsButton, self.savedGamesButton]
                      startingAtPoint:CGPointMake(self.view.bounds.size.width / 2.0f, 400.0f)
                     withIncrementsOf:40.0f];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.areFirstLoadAnimationsExecuted)
    {
        [self animateItems];
        self.areFirstLoadAnimationsExecuted = YES;
    }
}

#pragma mark - Private Methods

- (void)animateItems
{
    [self.logoImageView slideTo:[self.logoImageView frameShiftedVerticallyByOffset:-50.0f] duration:1.0f delay:0.0f];
    [self.quickPlayButton fadeInWithDuration:0.5f delay:1.0f];
    [self.patternsButton fadeInWithDuration:0.5f delay:1.0f];
    [self.savedGamesButton fadeInWithDuration:0.5f delay:1.0f];
}

- (void)quickGameButtonTapped:(id)sender
{
    [self.delegate quickGameButtonTapped];
}

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont defaultAppFontWithSize:18.0f]];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor appLightTextColor] forState:UIControlStateHighlighted];
    newButton.alpha = 0.0f;
    newButton.frame = CGRectMake(0.0f, 0.0f, 200.0f, 30.0f);
    newButton.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin
                    | UIViewAutoresizingFlexibleRightMargin
                    | UIViewAutoresizingFlexibleBottomMargin
                    | UIViewAutoresizingFlexibleLeftMargin;
    return newButton;
}

@end