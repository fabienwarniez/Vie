//
// Created by Fabien Warniez on 2015-04-08.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWSaveGameViewController.h"
#import "FWTextField.h"
#import "UIFont+FWAppFonts.h"
#import "UIColor+FWAppColors.h"
#import "UIImage+FWConvenience.h"

@implementation FWSaveGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSAttributedString *titleText = [[NSAttributedString alloc]
            initWithString:[@"cancel" uppercaseString]
                attributes:@{NSForegroundColorAttributeName: [UIColor darkGrey], NSFontAttributeName: [UIFont smallUppercase]}
    ];
    [self.cancelButton setAttributedTitle:titleText forState:UIControlStateNormal];

    UIImage *addImage = [self.addButton imageForState:UIControlStateNormal];
    UIImage *disabledAddImage = [addImage translucentImageWithAlpha:0.3f];
    [self.addButton setImage:disabledAddImage forState:UIControlStateDisabled];
    self.addButton.enabled = NO;
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Save";
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

- (IBAction)addButtonTapped:(UIButton *)addButton
{
    if (!addButton.selected) {
        [self.textField resignFirstResponder];
        addButton.selected = YES;
        [self.delegate saveGameViewController:self didSaveWithName:self.textField.text];
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)cancelButton
{
    [self cancel];
}

- (IBAction)textFieldValueDidChange:(FWTextField *)textField
{
    self.addButton.enabled = textField.text.length > 0;
}

- (IBAction)hideKeyboard:(FWTextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - Private Methods

- (void)cancel
{
    if (!self.addButton.selected) {
        [self.textField resignFirstResponder];
        [self.delegate saveGameViewControllerDidCancel:self];
    }
}

@end
