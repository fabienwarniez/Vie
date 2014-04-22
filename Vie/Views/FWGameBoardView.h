//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameBoardSizeModel;

@interface FWGameBoardView : UIView

@property (nonatomic, strong) FWGameBoardSizeModel *boardSize;
@property (nonatomic, assign) CGFloat boardPadding;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *fillColor;

@end