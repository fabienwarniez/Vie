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
    view.backgroundColor = [UIColor mainAppColor];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.center = CGPointMake(view.bounds.size.width / 2.0f, 200.0f);
    logoImageView.autoresizingMask =
            UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleLeftMargin;
    self.logoImageView = logoImageView;

    UIButton *quickPlayButton = [FWMainMenuViewController createMenuButtonWithTitle:@"quick play"];
    quickPlayButton.center = CGPointMake(view.bounds.size.width / 2.0f, 600.0f);
    quickPlayButton.alpha = 0.0f;
    self.quickPlayButton = quickPlayButton;

    UIButton *patternsButton = [FWMainMenuViewController createMenuButtonWithTitle:@"patterns"];
    patternsButton.center = CGPointMake(view.bounds.size.width / 2.0f, 700.0f);
    patternsButton.alpha = 0.0f;
    self.patternsButton = patternsButton;

    UIButton *savedGamesButton = [FWMainMenuViewController createMenuButtonWithTitle:@"saved games"];
    savedGamesButton.center = CGPointMake(view.bounds.size.width / 2.0f, 800.0f);
    savedGamesButton.alpha = 0.0f;
    self.savedGamesButton = savedGamesButton;

    [view addSubview:logoImageView];
    [view addSubview:quickPlayButton];
    [view addSubview:patternsButton];
    [view addSubview:savedGamesButton];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.quickPlayButton addTarget:self action:@selector(quickButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if (!self.areFirstLoadAnimationsExecuted)
    {
        [self.logoImageView slideTo:[self.logoImageView frameShiftedVerticallyByOffset:-50.0f] duration:1.0f delay:0];
        [self.quickPlayButton fadeInWithDuration:0.5f delay:1.0f];
        [self.patternsButton fadeInWithDuration:0.5f delay:1.0f];
        [self.savedGamesButton fadeInWithDuration:0.5f delay:1.0f];
        self.areFirstLoadAnimationsExecuted = YES;
    }
}

#pragma mark - Private Methods

- (void)quickButtonTapped:(UIButton *)button
{
    [self.delegate quickGameButtonTapped];
}

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont defaultAppFontWithSize:18.0f]];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [newButton sizeToFit];
    newButton.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin
                    | UIViewAutoresizingFlexibleRightMargin
                    | UIViewAutoresizingFlexibleBottomMargin
                    | UIViewAutoresizingFlexibleLeftMargin;
    return newButton;
}

@end