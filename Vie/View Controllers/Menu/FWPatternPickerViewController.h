//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWCellPatternModel;
@class FWBoardSizeModel;
@class FWPatternPickerViewController;

@protocol FWPatternPickerViewControllerDelegate

- (void)patternPicker:(FWPatternPickerViewController *)patternPickerViewController didSelectCellPattern:(FWCellPatternModel *)cellPattern;
- (void)patternPickerDidClose:(FWPatternPickerViewController *)patternPickerViewController;

@end

@interface FWPatternPickerViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, weak) id<FWPatternPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@end