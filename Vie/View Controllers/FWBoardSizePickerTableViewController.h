//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardSizeModel;

@protocol FWBoardSizePickerTableViewControllerDelegate <NSObject>

- (void)boardSizeDidChange:(FWBoardSizeModel *)newBoardSize;

@end

@interface FWBoardSizePickerTableViewController : UIViewController

@property (nonatomic, weak) id <FWBoardSizePickerTableViewControllerDelegate> delegate;

@end