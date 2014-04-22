//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemePickerTableViewController.h"

@class FWBoardSize;
@class FWGameViewController;

@interface FWMainViewController : UIViewController <FWColorSchemePickerTableViewControllerDelegate>

@property (nonatomic, strong) FWGameViewController *gameViewController;

- (id)initWithBoardSize:(FWBoardSize *)boardSize;

@end