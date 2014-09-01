//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIFont+FWAppFonts.h"

@implementation UIFont (FWAppFonts)

+ (UIFont *)defaultAppFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Gotham-Book" size:size];
}

@end