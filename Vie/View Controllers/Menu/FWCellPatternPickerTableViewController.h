//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWPatternModel;
@class FWBoardSizeModel;

@protocol FWCellPatternPickerTableViewControllerDelegate

- (void)didSelectCellPattern:(FWPatternModel *)cellPattern;

@end

@interface FWCellPatternPickerTableViewController : UIViewController

@property (nonatomic, weak) id<FWCellPatternPickerTableViewControllerDelegate> delegate;

@end