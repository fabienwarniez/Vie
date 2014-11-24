//
// Created by Fabien Warniez on 2014-05-05.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIColor+FWAppColors.h"

@implementation UIColor (FWAppColors)

+ (UIColor *)colorWithDecimalRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

+ (UIColor *)appPrimaryVibrantColor
{
    return [UIColor colorWithRed:94.0f / 255.0f green:172.0f / 255.0f blue:107.0f / 255.0f alpha:1.0f];
}

+ (UIColor *)appDarkTextColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)appLightTextColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)successfulBackgroundColor
{
    return [UIColor greenColor];
}

+ (UIColor *)selectedTableViewCellColor
{
    return [UIColor lightGrayColor];
}

@end