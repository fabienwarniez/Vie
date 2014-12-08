//
// Created by Fabien Warniez on 14-12-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//


#import "FWReflectiveTile.h"

@class FWSpeedTile;

@protocol FWSpeedTileDelegate <NSObject>

- (void)speedTileWasSelected:(FWSpeedTile *)selectedSpeedTile;

@end

@interface FWSpeedTile : FWReflectiveTile

@property (nonatomic, weak) id<FWSpeedTileDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image;
+ (instancetype)tileWithMainColor:(UIColor *)mainColor image:(UIImage *)image;

@end