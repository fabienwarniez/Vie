//
// Created by Fabien Warniez on 15-03-19.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWEditSavedGameViewController.h"
#import "FWTextField.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"
#import "UIImage+FWConvenience.h"
#import "FWSavedGameModel.h"

@implementation FWEditSavedGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textField.text = self.savedGame.name;

    NSAttributedString *titleText = [[NSAttributedString alloc]
            initWithString:[@"cancel" uppercaseString]
                attributes:@{NSForegroundColorAttributeName: [UIColor darkGrey], NSFontAttributeName: [UIFont smallUppercase]}
    ];
    [self.cancelButton setAttributedTitle:titleText forState:UIControlStateNormal];

    UIImage *okImage = [self.okButton imageForState:UIControlStateNormal];
    UIImage *disabledOkImage = [okImage translucentImageWithAlpha:0.3f];
    [self.okButton setImage:disabledOkImage forState:UIControlStateDisabled];
    [self updateOkButtonState];
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Edit";
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self cancel];
}

- (UIImage *)buttonImageFor:(FWTitleBar *)titleBar
{
    return [UIImage imageNamed:@"x"];
}

#pragma mark - IBAction

- (IBAction)okButtonTapped:(UIButton *)okButton
{
    if (!okButton.selected) {
        [self.textField resignFirstResponder];
        okButton.selected = YES;
        self.savedGame.name = self.textField.text;
        [self.savedGame.managedObjectContext save:nil];
        [self.delegate editSavedGameDidEdit:self];
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)cancelButton
{
    [self cancel];
}

- (IBAction)textFieldValueDidChange:(FWTextField *)textField
{
    [self updateOkButtonState];
}

- (IBAction)hideKeyboard:(FWTextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - Private Methods

- (void)updateOkButtonState
{
    self.okButton.enabled = self.textField.text.length > 0;
}

- (void)cancel
{
    if (!self.okButton.selected) {
        [self.textField resignFirstResponder];
        [self.delegate editSavedGameDidCancel:self];
    }
}

@end
