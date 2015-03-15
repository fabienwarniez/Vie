//
// Created by Fabien Warniez on 2015-04-08.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWSaveGameViewController;
@class FWTextField;

@protocol FWSaveGameViewControllerDelegate

- (void)saveGameViewControllerDidCancel:(FWSaveGameViewController *)saveGameViewController;
- (void)saveGameViewController:(FWSaveGameViewController *)saveGameViewController didSaveWithName:(NSString *)name;

@end

@interface FWSaveGameViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, weak) id<FWSaveGameViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet FWTextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *addButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

- (IBAction)addButtonTapped:(UIButton *)addButton;
- (IBAction)cancelButtonTapped:(UIButton *)cancelButton;
- (IBAction)textFieldValueDidChange:(FWTextField *)textField;
- (IBAction)hideKeyboard:(FWTextField *)textField;

@end
