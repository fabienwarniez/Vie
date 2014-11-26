//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//


@interface FWTileButton : UIControl

@property (nonatomic, strong) UIColor *mainColor;

- (instancetype)initWithMainColor:(UIColor *)mainColor;

+ (instancetype)buttonWithMainColor:(UIColor *)mainColor;

@end