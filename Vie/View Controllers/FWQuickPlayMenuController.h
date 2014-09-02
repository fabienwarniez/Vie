//
// Created by Fabien Warniez on 2014-09-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@protocol FWQuickPlayMenuControllerDelegate

- (void)menuCloseButtonTapped;
- (void)quitButtonTapped;

@end

@interface FWQuickPlayMenuController : UIViewController

@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) id<FWQuickPlayMenuControllerDelegate> delegate;

- (IBAction)closeButtonTapped:(id)sender;

@end