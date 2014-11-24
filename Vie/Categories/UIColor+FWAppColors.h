//
// Created by Fabien Warniez on 2014-05-05.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface UIColor (FWAppColors)

+ (UIColor *)colorWithDecimalRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *)appPrimaryVibrantColor;
+ (UIColor *)appDarkTextColor;
+ (UIColor *)appLightTextColor;
+ (UIColor *)successfulBackgroundColor;
+ (UIColor *)selectedTableViewCellColor;

@end