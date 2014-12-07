//
// Created by Fabien Warniez on 2014-05-05.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIColor+FWAppColors.h"

@implementation UIColor (FWAppColors)

//Vie Green #1bce7c         27  206 124
//Vie Green Dark #17af6a    23  175 106
//Dark Grey #626262         98  98  98
//Light Grey #ebeef0        235 238 240
//Medium Grey #cfd3d4       207 211 212
//Button Grey #e5e6e8       229 230 232
//Dark Blue #2c3e50         44  62  80
//Bright Pink #f62459       246 36  89

+ (UIColor *)vieGreen
{
    return [UIColor colorWithDecimalRed:27.0f green:206.0f blue:124.0f];
}

+ (UIColor *)vieGreenDark
{
    return [UIColor colorWithDecimalRed:23.0f green:175.0f blue:106.0f];
}

+ (UIColor *)darkGrey
{
    return [UIColor colorWithDecimalRed:98.0f green:98.0f blue:98.0f];
}

+ (UIColor *)lightGrey
{
    return [UIColor colorWithDecimalRed:235.0f green:238.0f blue:240.0f];
}

+ (UIColor *)mediumGrey
{
    return [UIColor colorWithDecimalRed:207.0f green:211.0f blue:212.0f];
}

+ (UIColor *)buttonGrey
{
    return [UIColor colorWithDecimalRed:229.0f green:230.0f blue:232.0f];
}

+ (UIColor *)darkBlue
{
    return [UIColor colorWithDecimalRed:44.0f green:62.0f blue:80.0f];
}

+ (UIColor *)brightPink
{
    return [UIColor colorWithDecimalRed:246.0f green:36.0f blue:89.0f];
}

#pragma mark - Private methods

+ (UIColor *)colorWithDecimalRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

@end