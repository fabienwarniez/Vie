//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWCell;

@interface FWCellView : UIView

@property (nonatomic, assign) NSUInteger column;
@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *fillColor;

@end