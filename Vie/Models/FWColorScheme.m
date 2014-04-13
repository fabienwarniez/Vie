//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorScheme.h"
#import "UIColor+FWConvenience.h"

@implementation FWColorScheme

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        NSString *fillColorHexString = [dictionary valueForKey:@"fill_color"];
        _fillColor = [UIColor colorWithHexString:fillColorHexString];

        NSString *borderColorHexString = [dictionary valueForKey:@"border_color"];
        _borderColor = [UIColor colorWithHexString:borderColorHexString];

        _colorSchemeName = [dictionary valueForKey:@"color_name"];
    }
    return self;
}

+ (instancetype)colorSchemeWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithFillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName
{
    self = [super init];
    if (self)
    {
        _fillColor = fillColor;
        _borderColor = borderColor;
        _colorSchemeName = colorSchemeName;
    }
    return self;
}

+ (instancetype)colorSchemeWithFillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName
{
    return [[self alloc] initWithFillColor:fillColor borderColor:borderColor colorSchemeName:colorSchemeName];
}

@end