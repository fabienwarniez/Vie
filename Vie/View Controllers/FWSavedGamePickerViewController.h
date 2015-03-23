//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWBoardSizeModel;
@class FWTextField;
@class FWColorSchemeModel;
@class FWSavedGamePickerViewController;
@class FWSavedGameModel;

@protocol FWSavedGamePickerViewControllerDelegate

- (void)savedGamePicker:(FWSavedGamePickerViewController *)savedGamePickerViewController didSelectSavedGame:(FWSavedGameModel *)savedGame;
- (void)savedGamePickerDidClose:(FWSavedGamePickerViewController *)savedGamePickerViewController;

@end

@interface FWSavedGamePickerViewController : UIViewController <FWTitleBarDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<FWSavedGamePickerViewControllerDelegate> delegate;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) IBOutlet UIView *searchBarContainer;
@property (nonatomic, strong) IBOutlet FWTextField *searchBar;
@property (nonatomic, strong) IBOutlet UIView *noResultContainer;
@property (nonatomic, strong) IBOutlet UILabel *noResultLabel;

- (IBAction)textFieldChanged:(FWTextField *)textField;
- (IBAction)hideKeyboard:(FWTextField *)textField;

@end
