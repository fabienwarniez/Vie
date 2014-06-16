//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWMainViewController.h"
#import "FWGameViewController.h"
#import "FWBoardSizeModel.h"
#import "FWColorSchemeModel.h"
#import "FWAppDelegate.h"
#import "FWUserModel.h"
#import "FWSavedGame.h"
#import "FWCellPatternModel.h"

static CGFloat const kFWMainViewControllerMenuWidthPad = 320.0f;
static CGFloat const kFWMainViewControllerMenuWidthPhone = 240.0f;
static CGFloat const kFWGameViewControllerCellBorderWidth = 1.0f;

@interface FWMainViewController () <UINavigationBarDelegate>

@property (nonatomic, strong) FWGameViewController *gameViewController;
@property (nonatomic, assign) BOOL isMenuExpanded;

@end

@implementation FWMainViewController

#pragma mark - Initializers

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        FWUserModel *userModel = [FWUserModel sharedUserModel];

        _gameViewController = [[FWGameViewController alloc] initWithNibName:@"FWGameViewController" bundle:nil];
        _gameViewController.boardSize = userModel.gameBoardSize;
        _gameViewController.cellBorderWidth = kFWGameViewControllerCellBorderWidth;
        _gameViewController.cellFillColorScheme = userModel.colorScheme;

        _isMenuExpanded = NO;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationBar.layer.shadowOpacity = 0.3f;
    self.navigationBar.layer.shadowOffset = CGSizeZero;
    self.navigationBar.layer.shadowRadius = 3.0f;
    self.navigationBar.layer.masksToBounds = NO;

    [self addChildViewController:self.gameViewController];
    self.gameViewController.view.frame = self.gameBoardContainerView.bounds;
    self.gameViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.gameBoardContainerView addSubview:self.gameViewController.view];
    [self.gameViewController didMoveToParentViewController:self];

    CGRect navigationContainerFrame = self.menuNavigationControllerContainerView.frame;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        navigationContainerFrame.size.width = kFWMainViewControllerMenuWidthPad;
    }
    else // iPhone
    {
        navigationContainerFrame.size.width = kFWMainViewControllerMenuWidthPhone;
    }
    self.menuNavigationControllerContainerView.frame = navigationContainerFrame;

    self.menuNavigationController.navigationBar.tintColor = [UIColor whiteColor]; // needed to make the back arrow white
    self.menuNavigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuNavigationController.navigationBar.layer.shadowOpacity = 0.3f;
    self.menuNavigationController.navigationBar.layer.shadowOffset = CGSizeZero;
    self.menuNavigationController.navigationBar.layer.shadowRadius = 3.0f;
    self.menuNavigationController.navigationBar.layer.masksToBounds = NO;
    self.menuNavigationController.view.frame = self.menuNavigationControllerContainerView.bounds;
    self.menuNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.menuNavigationControllerContainerView addSubview:self.menuNavigationController.view];

    self.mainMenuViewController.delegate = self;
}

#pragma mark - IBAction's

- (IBAction)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (!self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self openMenu];
    }
    else if (self.isMenuExpanded && swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self closeMenu];
    }
}

- (IBAction)handleMenuButtonTapped:(id)sender
{
    if (self.isMenuExpanded)
    {
        [self closeMenu];
    }
    else
    {
        [self openMenu];
    }
}

- (IBAction)handleGameBoardOverlayTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self closeMenu];
}

#pragma mark - FWMainMenuViewControllerDelegate

- (void)saveCurrentGame
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [dateFormatter stringFromDate:now];

    NSArray *liveCells = [self.gameViewController initialBoardLiveCells];

    FWSavedGame *savedGame = [FWSavedGame gameWithName:dateString boardSize:self.gameViewController.boardSize liveCells:liveCells];

    FWUserModel *userModel = [FWUserModel sharedUserModel];
    [userModel addSavedGame:savedGame];

    // TODO: display confirmation message
}

#pragma mark - FWColorSchemePickerTableViewControllerDelegate

- (void)colorSchemeDidChange:(FWColorSchemeModel *)newColorScheme
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setColorScheme:newColorScheme];

    self.gameViewController.cellFillColorScheme = newColorScheme;
}

#pragma mark - FWBoardSizePickerTableViewControllerDelegate

- (void)boardSizeDidChange:(FWBoardSizeModel *)newBoardSize
{
    FWUserModel *sharedUserModel = [FWUserModel sharedUserModel];
    [sharedUserModel setGameBoardSize:newBoardSize];

    self.gameViewController.boardSize = newBoardSize;
    [self.gameViewController setForceResumeAfterInterruption:NO];
}

#pragma mark - FWSavedGamePickerTableViewControllerDelegate

- (void)loadSavedGame:(FWSavedGame *)savedGame
{
    [self.gameViewController loadSavedGame:savedGame];

    [self.gameViewController setForceResumeAfterInterruption:NO];
    [self closeMenu];
}

#pragma mark - FWCellPatternPickerTableViewControllerDelegate

- (void)didSelectCellPattern:(FWCellPatternModel *)cellPattern
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, cellPattern.name);

    [self.gameViewController setPattern:cellPattern];

    [self.gameViewController setForceResumeAfterInterruption:NO];
    [self closeMenu];
}

#pragma mark - UINavigationToolbarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - Private Methods

- (void)openMenu
{
    [self.gameViewController interruptGame];

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newFrame = self.mainContentContainerView.frame;
                         newFrame.origin.x += self.menuNavigationControllerContainerView.frame.size.width;
                         self.mainContentContainerView.frame = newFrame;
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished)
                         {
                             self.isMenuExpanded = YES;
                             self.gameBoardOverlayView.hidden = NO;
                         }
                     }];
}

- (void)closeMenu
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newFrame = self.mainContentContainerView.frame;
                         newFrame.origin.x = 0;
                         self.mainContentContainerView.frame = newFrame;
                     }
                     completion:^(BOOL finished)
                     {
                         if (finished)
                         {
                             [self.gameViewController resumeAfterInterruption];
                             self.isMenuExpanded = NO;
                             self.gameBoardOverlayView.hidden = YES;
                         }
                     }];
}

@end