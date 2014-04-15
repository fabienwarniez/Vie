//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIColor+FWConvenience.h"

@implementation UIColor (FWConvenience)

+ (instancetype)colorWithHexString:(NSString *)hexString
{
    NSUInteger red, green, blue;
    sscanf([hexString UTF8String], "%02X%02X%02X", &red, &green, &blue);
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

@end