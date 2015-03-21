//
// Created by Fabien Warniez on 15-03-20.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class FWDeleteButton;

@protocol FWDeleteButtonDelegate <NSObject>

- (void)deleteButtonDidDelete:(FWDeleteButton *)deleteButton;

@end

@interface FWDeleteButton : UIControl

@property (nonatomic, weak) id<FWDeleteButtonDelegate> delegate;

@end