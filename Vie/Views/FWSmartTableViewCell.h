//
// Created by Fabien Warniez on 2014-05-04.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWSmartTableViewCell;

@protocol FWSmartTableViewCellDelegate <NSObject>

- (void)accessoryButtonTapped:(FWSmartTableViewCell *)sender;

@end

@interface FWSmartTableViewCell : UITableViewCell

@property (nonatomic, weak) id<FWSmartTableViewCellDelegate> delegate;

- (void)showSaveButton;
- (void)markAsCompleteFor:(NSTimeInterval)seconds;

@end