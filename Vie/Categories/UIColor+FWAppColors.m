//
// Created by Fabien Warniez on 2014-05-05.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIColor+FWAppColors.h"

@implementation UIColor (FWAppColors)

+ (UIColor *)successfulBackgroundColor
{
    return [UIColor colorWithRed:198.0f/255.0f green:241.0f/255.0f blue:150.0f/255.0f alpha:1.0];
}

+ (UIColor *)selectedTableViewCellColor
{
    return [UIColor lightGrayColor];
}

@end