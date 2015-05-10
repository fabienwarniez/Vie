//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIFont+FWAppFonts.h"

@implementation UIFont (FWAppFonts)

+ (UIFont *)smallCondensed
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:15.0f];
}

+ (UIFont *)smallCondensedBold
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14.0f];
}

+ (UIFont *)largeCondensedBold
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:18.0f];
}

+ (UIFont *)largeCondensedRegular
{
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:18.0f];
}

+ (UIFont *)tinyBold
{
    return [UIFont fontWithName:@"AvenirNext-Bold" size:12.0f];
}

+ (UIFont *)largeBold
{
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
}

+ (UIFont *)microRegular
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:8.0f];
}

+ (UIFont *)tinyRegular
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:13.0f];
}

+ (UIFont *)largeRegular
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:18.0f];
}

+ (UIFont *)smallRegular
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f];
}

+ (UIFont *)smallUppercase
{
    return [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
}

@end