//
// Created by Fabien Warniez on 2014-09-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWQuickPlayMenuController.h"
#import "UIFont+FWAppFonts.h"
#import "UIColor+FWAppColors.h"
#import "UIView+FWConvenience.h"
#import "FWGameSettingsViewController.h"
#import "FWColorSchemeModel.h"
#import "FWBoardSizeModel.h"

@interface FWQuickPlayMenuController () <UINavigationBarDelegate, FWGameSettingsViewControllerDelegate>

@property (nonatomic, strong) FWGameSettingsViewController *gameSettingsViewController;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *createGameButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UIButton *quitButton;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;

@property (nonatomic, assign) BOOL areGameSettingsVisible;

@end

@implementation FWQuickPlayMenuController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _areGameSettingsVisible = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.saveButton = [FWQuickPlayMenuController createMenuButtonWithTitle:@"save"];
    self.createGameButton = [FWQuickPlayMenuController createMenuButtonWithTitle:@"new game"];
    self.settingsButton = [FWQuickPlayMenuController createMenuButtonWithTitle:@"settings"];
    self.quitButton = [FWQuickPlayMenuController createMenuButtonWithTitle:@"quit"];

    [self.saveButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.createGameButton addTarget:self action:@selector(createGameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(settingsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.quitButton addTarget:self action:@selector(quitButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    self.line1 = [FWQuickPlayMenuController createLineOfWidth:140.0f];
    self.line2 = [FWQuickPlayMenuController createLineOfWidth:140.0f];
    self.line3 = [FWQuickPlayMenuController createLineOfWidth:140.0f];
    self.line4 = [FWQuickPlayMenuController createLineOfWidth:140.0f];

    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.createGameButton];
    [self.view addSubview:self.settingsButton];
    [self.view addSubview:self.quitButton];

    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    [self.view addSubview:self.line4];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [UIView distributeVerticallyViews:@[self.saveButton, self.line1, self.createGameButton, self.line2, self.settingsButton, self.line3, self.quitButton, self.line4]
                      startingAtPoint:CGPointMake(self.view.bounds.size.width / 2.0f, 150.0f)
                     withIncrementsOf:30.5f];
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - FWGameSettingsViewControllerDelegate

- (void)gameSettingsDidClose:(FWGameSettingsViewController *)gameSettingsViewController
{
    self.areGameSettingsVisible = NO;
}

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController colorSchemeDidChange:(FWColorSchemeModel *)newColorScheme
{

}

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController boardSizeDidChange:(FWBoardSizeModel *)newBoardSize
{

}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender
{
    [self.view slideTo:[self.parentViewController.view frameBelow] duration:0.3f delay:0.0f];
    [self.delegate quickPlayMenuDidClose:self];
}

#pragma mark - Private Methods

- (void)saveButtonTapped:(id)sender
{

}

- (void)createGameButtonTapped:(id)sender
{

}

- (void)settingsButtonTapped:(id)sender
{
    if (self.gameSettingsViewController == nil)
    {
        FWGameSettingsViewController *gameSettingsViewController = [[FWGameSettingsViewController alloc] initWithNibName:@"FWGameSettingsViewController" bundle:nil];
        gameSettingsViewController.delegate = self;
        [self addChildViewController:gameSettingsViewController];
        gameSettingsViewController.view.frame = [self.view frameBelow];
        [self.view addSubview:gameSettingsViewController.view];
        [gameSettingsViewController didMoveToParentViewController:self];
        self.gameSettingsViewController = gameSettingsViewController;
    }
    else
    {
        [self addChildViewController:self.gameSettingsViewController];
        self.gameSettingsViewController.view.frame = [self.view frameBelow];
        [self.view addSubview:self.gameSettingsViewController.view];
        [self.gameSettingsViewController didMoveToParentViewController:self];
    }
    [self.gameSettingsViewController.view slideTo:self.view.bounds duration:0.3f delay:0.0f];
}

- (void)quitButtonTapped:(id)sender
{
    [self.delegate quit];
}

+ (UIButton *)createMenuButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton.titleLabel setFont:[UIFont defaultAppFontWithSize:20.0f]];
    [newButton setTitleColor:[UIColor appDarkTextColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor appLightTextColor] forState:UIControlStateHighlighted];
    newButton.frame = CGRectMake(0.0f, 0.0f, 200.0f, 32.0f);
    newButton.autoresizingMask =
            UIViewAutoresizingFlexibleTopMargin
                    | UIViewAutoresizingFlexibleRightMargin
                    | UIViewAutoresizingFlexibleBottomMargin
                    | UIViewAutoresizingFlexibleLeftMargin;
    return newButton;
}

+ (UIView *)createLineOfWidth:(CGFloat)width
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    lineView.backgroundColor = [UIColor appLightTextColor];
    return lineView;
}

@end