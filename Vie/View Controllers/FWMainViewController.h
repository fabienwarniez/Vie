//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWBoardSizePickerTableViewController.h"
#import "FWMainMenuViewController.h"
#import "FWSavedGamePickerTableViewController.h"

@class FWBoardSizeModel;
@class FWGameViewController;
@class FWMainMenuViewController;

@interface FWMainViewController : UIViewController
        <FWColorSchemePickerTableViewControllerDelegate,
        FWBoardSizePickerTableViewControllerDelegate,
        FWMainMenuViewControllerDelegate, FWSavedGamePickerTableViewControllerDelegate>

@property (nonatomic, strong) IBOutlet FWMainMenuViewController *mainMenuViewController;
@property (nonatomic, strong) IBOutlet UINavigationController *menuNavigationController;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UIView *menuNavigationControllerContainerView;
@property (nonatomic, strong) IBOutlet UIView *mainContentContainerView;
@property (nonatomic, strong) IBOutlet UIView *gameBoardContainerView;

- (IBAction)handleNavigationSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer;
- (IBAction)handleMenuButtonTapped:(id)sender;

@end