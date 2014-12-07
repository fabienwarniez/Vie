//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWReflectiveTile.h"

@class FWColorTile;

@protocol FWColorTileDelegate <NSObject>

- (void)tileButtonWasSelected:(FWColorTile *)tileButton;

@end

@interface FWColorTile : FWReflectiveTile

@property (nonatomic, weak) id<FWColorTileDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image;
+ (instancetype)buttonWithMainColor:(UIColor *)mainColor image:(UIImage *)image;

@end