//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainMenuViewController.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"
#import "UIView+FWConvenience.h"

@interface FWMainMenuViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *quickPlayButton;
@property (nonatomic, strong) UIButton *patternsButton;
@property (nonatomic, strong) UIButton *favouritesButton;
@property (nonatomic, strong) UIButton *savedGamesButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UILabel *copyrightLabel;
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

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    self.backgroundImageView = backgroundImageView;

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImageView.autoresizingMask =
            UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleLeftMargin;
    self.logoImageView = logoImageView;

    self.quickPlayButton = [FWMainMenuViewController createMenuButtonWithTitle:@"Quick Play"];
    self.patternsButton = [FWMainMenuViewController createMenuButtonWithTitle:@"Patterns"];
    self.favouritesButton = [FWMainMenuViewController createMenuButtonWithTitle:@"Favourites"];
    self.savedGamesButton = [FWMainMenuViewController createMenuButtonWithTitle:@"Saved Games"];
    self.aboutButton = [FWMainMenuViewController createMenuButtonWithTitle:@"About"];

    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.text = NSLocalizedString(@"© 2014 dot dot software, inc.", @"© 2014 dot dot software, inc.");
    self.copyrightLabel.font = [UIFont tinyBold];
    self.copyrightLabel.textColor = [UIColor whiteColor];

    [view addSubview:backgroundImageView];
    [view addSubview:logoImageView];
    [view addSubview:self.quickPlayButton];
    [view addSubview:self.patternsButton];
    [view addSubview:self.favouritesButton];
    [view addSubview:self.savedGamesButton];
    [view addSubview:self.aboutButton];
    [view addSubview:self.copyrightLabel];

    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.quickPlayButton addTarget:self action:@selector(quickGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.patternsButton addTarget:self action:@selector(patternsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.savedGamesButton addTarget:self action:@selector(savedGamesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.backgroundImageView.frame = CGRectMake(
            (self.view.bounds.size.width - self.backgroundImageView.frame.size.width) / 2.0f,
            0,
            self.backgroundImageView.frame.size.width,
            self.backgroundImageView.frame.size.height
    );
    self.logoImageView.center = CGPointMake(self.view.bounds.size.width / 2.0f + 23, 186.0f);

    [UIView distributeVerticallyViews:@[self.quickPlayButton, self.patternsButton, self.favouritesButton, self.savedGamesButton, self.aboutButton]
                      startingAtPoint:CGPointMake(self.view.bounds.size.width / 2.0f, 280.0f)
                     withIncrementsOf:50.0f];

    [self.copyrightLabel sizeToFit];
    CGRect copyrightFrame = self.copyrightLabel.frame;
    copyrightFrame.origin.x = (self.view.bounds.size.width - copyrightFrame.size.width) / 2.0f;
    copyrightFrame.origin.y = self.view.bounds.size.height - copyrightFrame.size.height - 12.0f;
    self.copyrightLabel.frame = copyrightFrame;
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
    [self.logoImageView slideTo:[self.logoImageView frameShiftedVerticallyByOffset:-100.0f] duration:1.0f delay:0.5f completion:nil];
    [self.quickPlayButton fadeInWithDuration:0.5f delay:1.5f];
    [self.patternsButton fadeInWithDuration:0.5f delay:1.5f];
    [self.favouritesButton fadeInWithDuration:0.5f delay:1.5f];
    [self.savedGamesButton fadeInWithDuration:0.5f delay:1.5f];
    [self.aboutButton fadeInWithDuration:0.5f delay:1.5f];
}

- (void)quickGameButtonTapped:(UIButton *)quickGameButton
{
    [self.delegate quickGameButtonTapped];
}

- (void)patternsButtonTapped:(UIButton *)patternsButton
{
    [self.delegate patternsButtonTapped];
}

- (void)savedGamesButtonTapped:(UIButton *)savedGamesButton
{
    [self.delegate savedGamesButtonTapped];
}

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont largeBold]];
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor lightGrey] forState:UIControlStateHighlighted];
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