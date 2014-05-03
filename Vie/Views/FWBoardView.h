//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardSizeModel;

@interface FWBoardView : UIView

@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, assign) CGFloat minimumBoardPadding;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *fillColor;

@end