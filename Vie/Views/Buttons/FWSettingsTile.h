//
// Created by Fabien Warniez on 15-01-25.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWReflectiveTile.h"

@class FWSettingsTile;

@protocol FWSettingsTileDelegate <NSObject>

- (void)tileButtonWasSelected:(FWSettingsTile *)tileButton;

@end

@interface FWSettingsTile : FWReflectiveTile

@property (nonatomic, weak) id<FWSettingsTileDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle;

+ (instancetype)tileWithMainColor:(UIColor *)mainColor image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle;


@end