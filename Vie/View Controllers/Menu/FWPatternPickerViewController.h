//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWPatternModel;
@class FWBoardSizeModel;
@class FWPatternPickerViewController;
@class FWTextField;
@class FWColorSchemeModel;

@protocol FWPatternPickerViewControllerDelegate

- (void)patternPicker:(FWPatternPickerViewController *)patternPickerViewController didSelectCellPattern:(FWPatternModel *)cellPattern;
- (void)patternPickerDidClose:(FWPatternPickerViewController *)patternPickerViewController;

@end

@interface FWPatternPickerViewController : UIViewController <FWTitleBarDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<FWPatternPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong) IBOutlet UIView *searchBarContainer;
@property (nonatomic, strong) IBOutlet FWTextField *searchBar;
@property (nonatomic, strong) IBOutlet UIView *noResultContainer;
@property (nonatomic, strong) IBOutlet UILabel *noResultLabel;

- (IBAction)textFieldChanged:(FWTextField *)textField;
- (IBAction)hideKeyboard:(FWTextField *)textField;

@end