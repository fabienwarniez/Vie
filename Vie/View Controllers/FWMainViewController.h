//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"
#import "FWBoardSizePickerTableViewController.h"

@class FWBoardSizeModel;
@class FWGameViewController;

@interface FWMainViewController : UIViewController <FWColorSchemePickerTableViewControllerDelegate, FWBoardSizePickerTableViewControllerDelegate>

@property (nonatomic, strong) FWGameViewController *gameViewController;

@end