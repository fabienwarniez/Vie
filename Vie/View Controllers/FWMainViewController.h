//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWBoardSizePickerTableViewController.h"
#import "FWMainMenuTableViewController.h"
#import "FWSavedGamePickerTableViewController.h"
#import "FWCellPatternPickerTableViewController.h"

@class FWBoardSizeModel;
@class FWGameViewController;
@class FWMainMenuTableViewController;

@interface FWMainViewController : UIViewController
        <FWColorSchemePickerTableViewControllerDelegate,
        FWBoardSizePickerTableViewControllerDelegate,
        FWMainMenuViewControllerDelegate,
        FWSavedGamePickerTableViewControllerDelegate,
        FWCellPatternPickerTableViewControllerDelegate>

@property (nonatomic, strong) IBOutlet FWMainMenuTableViewController *mainMenuViewController;
@property (nonatomic, strong) IBOutlet UINavigationController *menuNavigationController;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UIView *menuNavigationControllerContainerView;
@property (nonatomic, strong) IBOutlet UIView *mainContentContainerView;
@property (nonatomic, strong) IBOutlet UIView *gameBoardContainerView;
@property (nonatomic, strong) IBOutlet UIView *gameBoardOverlayView;

- (IBAction)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer;
- (IBAction)handleMenuButtonTapped:(id)sender;
- (IBAction)handleGameBoardOverlayTapped:(UITapGestureRecognizer *)tapGestureRecognizer;

@end