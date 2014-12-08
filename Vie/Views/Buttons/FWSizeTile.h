//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWReflectiveTile.h"

@class FWSizeTile;

@protocol FWSizeTileDelegate <NSObject>

- (void)sizeTileWasSelected:(FWSizeTile *)sizeTile;

@end

@interface FWSizeTile : FWReflectiveTile

@property (nonatomic, weak) id<FWSizeTileDelegate> delegate;
@property (nonatomic, strong) UIColor *squareColor;
@property (nonatomic, assign) NSUInteger widthAsPercentage;

- (instancetype)initWithMainColor:(UIColor *)mainColor squareColor:(UIColor *)squareColor squareWidthAsPercentage:(NSUInteger)percentage;
+ (instancetype)tileWithMainColor:(UIColor *)mainColor squareColor:(UIColor *)squareColor squareWidthAsPercentage:(NSUInteger)percentage;

@end