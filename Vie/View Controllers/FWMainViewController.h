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
        FWMainMenuTableViewControllerDelegate,
        FWSavedGamePickerTableViewControllerDelegate,
        FWCellPatternPickerTableViewControllerDelegate>

@end