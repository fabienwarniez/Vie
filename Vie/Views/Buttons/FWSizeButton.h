//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWReflectiveButton.h"

@class FWSizeButton;

@protocol FWSizeButtonDelegate <NSObject>

- (void)tileButtonWasSelected:(FWSizeButton *)tileButton;

@end

@interface FWSizeButton : FWReflectiveButton

@property (nonatomic, weak) id<FWSizeButtonDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image;
+ (instancetype)buttonWithMainColor:(UIColor *)mainColor image:(UIImage *)image;

@end