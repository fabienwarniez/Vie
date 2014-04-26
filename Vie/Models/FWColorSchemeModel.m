//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeModel.h"
#import "UIColor+FWConvenience.h"

@implementation FWColorSchemeModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _guid = [dictionary valueForKey:@"guid"];

        NSString *fillColorHexString = [dictionary valueForKey:@"fill_color"];
        _fillColor = [UIColor colorWithHexString:fillColorHexString];

        NSString *borderColorHexString = [dictionary valueForKey:@"border_color"];
        _borderColor = [UIColor colorWithHexString:borderColorHexString];

        _colorSchemeName = [dictionary valueForKey:@"color_name"];

        if (_guid == nil || _fillColor == nil || _borderColor == nil || _colorSchemeName == nil)
        {
            self = nil;
        }
    }
    return self;
}

+ (instancetype)colorSchemeWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName
{
    self = [super init];
    if (self)
    {
        _guid = guid;
        _fillColor = fillColor;
        _borderColor = borderColor;
        _colorSchemeName = colorSchemeName;
    }
    return self;
}

+ (instancetype)colorSchemeWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName
{
    return [[self alloc] initWithGuid:nil fillColor:fillColor borderColor:borderColor colorSchemeName:colorSchemeName];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    else if (!other || ![[other class] isEqual:[self class]])
    {
        return NO;
    }
    else
    {
        return [self isEqualToColorScheme:other];
    }
}

- (BOOL)isEqualToColorScheme:(FWColorSchemeModel *)otherColorScheme
{
    return self.guid == otherColorScheme.guid;
}

+ (NSArray *)colorSchemesFromFile
{
    NSMutableArray *colorSchemes = [NSMutableArray array];

    NSArray *colorList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"]];
    NSAssert(colorList != nil, @"Colors.plist is corrupted. Root object is not an array.");
    for (NSDictionary *colorDictionary in colorList)
    {
        FWColorSchemeModel *colorObject = [FWColorSchemeModel colorSchemeWithDictionary:colorDictionary];
        NSAssert(colorObject != nil, @"Colors.plist is corrupted. At least one entry did not contain valid values.");
        [colorSchemes addObject:colorObject];
    }

    return [colorSchemes copy];
}

+ (FWColorSchemeModel *)colorSchemeFromGuid:(NSString *)guid inArray:(NSArray *)array
{
    FWColorSchemeModel *userColorScheme = nil;
    for (FWColorSchemeModel *colorSchemeIterator in array)
    {
        if ([colorSchemeIterator.guid isEqualToString:guid])
        {
            userColorScheme = colorSchemeIterator;
        }
    }
    return userColorScheme;
}

@end