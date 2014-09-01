//
// Created by Fabien Warniez on 2014-03-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWMainViewController;

@protocol FWMainMenuTableViewControllerDelegate

- (void)saveCurrentGame;

@end

@interface FWMainMenuTableViewController : UIViewController

@property (nonatomic, weak) id<FWMainMenuTableViewControllerDelegate> delegate;

@property (nonatomic, weak) IBOutlet FWMainViewController *mainViewController;

@end