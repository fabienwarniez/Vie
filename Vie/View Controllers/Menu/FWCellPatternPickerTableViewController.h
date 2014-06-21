//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWCellPatternModel;
@class FWBoardSizeModel;

@protocol FWCellPatternPickerTableViewControllerDelegate

- (void)didSelectCellPattern:(FWCellPatternModel *)cellPattern;

@end

@interface FWCellPatternPickerTableViewController : UIViewController

@property (nonatomic, weak) id<FWCellPatternPickerTableViewControllerDelegate> delegate;

@end