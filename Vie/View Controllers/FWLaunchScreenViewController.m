//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWLaunchScreenViewController.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"
#import "UIView+FWConvenience.h"

@interface FWLaunchScreenViewController ()

@property (nonatomic, strong) UIButton *quickPlayButton;
@property (nonatomic, strong) UIButton *patternsButton;
@property (nonatomic, strong) UIButton *savedGamesButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UILabel *copyrightLabel;
@property (nonatomic, assign) BOOL areFirstLoadAnimationsExecuted;

@end

@implementation FWLaunchScreenViewController

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

- (void)viewDidLoad
{
    self.quickPlayButton = [FWLaunchScreenViewController createMenuButtonWithTitle:NSLocalizedString(@"launch.quick-play", @"Quick Play")];
    self.patternsButton = [FWLaunchScreenViewController createMenuButtonWithTitle:NSLocalizedString(@"launch.patterns", @"Patterns")];
    self.savedGamesButton = [FWLaunchScreenViewController createMenuButtonWithTitle:NSLocalizedString(@"launch.saved-games", @"Saved Games")];
    self.aboutButton = [FWLaunchScreenViewController createMenuButtonWithTitle:NSLocalizedString(@"launch.about", @"About")];

    [self.quickPlayButton addTarget:self action:@selector(quickGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.patternsButton addTarget:self action:@selector(patternsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.savedGamesButton addTarget:self action:@selector(savedGamesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.aboutButton addTarget:self action:@selector(aboutButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    self.copyrightLabel = [[UILabel alloc] init];
    self.copyrightLabel.text = NSLocalizedString(@"launch.copyright", @"© 2016 (fabien & katrina) warniez");
    self.copyrightLabel.font = [UIFont tinyBold];
    self.copyrightLabel.textColor = [UIColor whiteColor];

    [self.view addSubview:self.quickPlayButton];
    [self.view addSubview:self.patternsButton];
    [self.view addSubview:self.savedGamesButton];
    [self.view addSubview:self.aboutButton];
    [self.view addSubview:self.copyrightLabel];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self.copyrightLabel sizeToFit];
    CGRect copyrightFrame = self.copyrightLabel.frame;
    copyrightFrame.origin.x = FWRoundFloat((self.view.bounds.size.width - copyrightFrame.size.width) / 2.0f);
    copyrightFrame.origin.y = self.view.bounds.size.height - copyrightFrame.size.height - 12.0f;
    self.copyrightLabel.frame = copyrightFrame;

    NSArray *buttons = @[self.quickPlayButton, self.patternsButton, self.savedGamesButton, self.aboutButton];
    CGFloat availableHeight = self.copyrightLabel.frame.origin.y - CGRectGetMaxY(self.logoImageView.frame);
    CGFloat buttonSpacing = [UIView verticalSpaceToDistributeViews:buttons inAvailableVerticalSpace:availableHeight];
    [UIView distributeVerticallyViews:buttons
                      startingAtPoint:CGPointMake(FWRoundFloat(self.view.bounds.size.width / 2.0f), CGRectGetMaxY(self.logoImageView.frame) + buttonSpacing)
                          withSpacing:buttonSpacing];
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
    [self.logoImageView slideTo:[self.logoImageView frameWithY:50.0f] duration:0.7f delay:0.4f completion:nil];
    [self.quickPlayButton fadeInWithDuration:0.5f delay:1.0f];
    [self.patternsButton fadeInWithDuration:0.5f delay:1.0f];
    [self.savedGamesButton fadeInWithDuration:0.5f delay:1.0f];
    [self.aboutButton fadeInWithDuration:0.5f delay:1.0f];
}

- (void)quickGameButtonTapped:(UIButton *)quickGameButton
{
    [self.delegate quickGameButtonTappedForLaunchScreen:self];
}

- (void)patternsButtonTapped:(UIButton *)patternsButton
{
    [self.delegate patternsButtonTappedForLaunchScreen:self];
}

- (void)savedGamesButtonTapped:(UIButton *)savedGamesButton
{
    [self.delegate savedGamesButtonTappedForLaunchScreen:self];
}

- (void)aboutButtonTapped:(UIButton *)aboutButton
{
    [self.delegate aboutButtonTappedForLaunchScreen:self];
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
