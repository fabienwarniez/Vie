//
// Created by Fabien Warniez on 15-03-19.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWEditSavedGameViewController;
@class FWTextField;
@class FWSavedGameModel;
@class FWDeleteButton;

@protocol FWEditSavedGameViewControllerDelegate <NSObject>

- (void)editSavedGameDidEdit:(FWEditSavedGameViewController *)editSavedGameViewController;
- (void)editSavedGameDidDelete:(FWEditSavedGameViewController *)editSavedGameViewController;
- (void)editSavedGameDidCancel:(FWEditSavedGameViewController *)editSavedGameViewController;

@end

@interface FWEditSavedGameViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, weak) id<FWEditSavedGameViewControllerDelegate> delegate;
@property (nonatomic, strong) FWSavedGameModel *savedGame;
@property (nonatomic, strong) IBOutlet FWTextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *okButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) IBOutlet FWDeleteButton *deleteButton;

- (IBAction)okButtonTapped:(UIButton *)okButton;
- (IBAction)cancelButtonTapped:(UIButton *)cancelButton;
- (IBAction)textFieldValueDidChange:(FWTextField *)textField;
- (IBAction)hideKeyboard:(FWTextField *)textField;

@end