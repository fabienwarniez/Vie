//
// Created by Fabien Warniez on 2014-05-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWSavedGameTableViewCell;

@protocol FWSavedGameTableViewCellDelegate

@optional

- (void)savedGameCell:(FWSavedGameTableViewCell *)savedGameCell didEditGameName:(NSString *)name;

@end

@interface FWSavedGameTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) NSString *updatedText;
@property (nonatomic, weak) id<FWSavedGameTableViewCellDelegate> delegate;

@end