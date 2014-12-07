//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeModel.h"

static NSArray *kFWColorSchemeList = nil;

@implementation FWColorSchemeModel

- (instancetype)initWithGuid:(NSString *)guid youngFillColor:(UIColor *)youngFillColor mediumFillColor:(UIColor *)mediumFillColor oldFillColor:(UIColor *)oldFillColor
{
    self = [super init];
    if (self)
    {
        _guid = guid;
        _youngFillColor = youngFillColor;
        _mediumFillColor = mediumFillColor != nil ? mediumFillColor : youngFillColor;
        _oldFillColor = oldFillColor != nil ? oldFillColor : youngFillColor;
    }
    return self;
}

+ (instancetype)colorSchemeWithGuid:(NSString *)guid youngFillColor:(UIColor *)youngFillColor mediumFillColor:(UIColor *)mediumFillColor oldFillColor:(UIColor *)oldFillColor
{
    return [[self alloc] initWithGuid:guid youngFillColor:youngFillColor mediumFillColor:mediumFillColor oldFillColor:oldFillColor];
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
    return [self.guid isEqualToString:otherColorScheme.guid];
}

- (NSUInteger)hash
{
    return [self.guid hash];
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

+ (NSArray *)colors
{
    if (kFWColorSchemeList == nil)
    {
        kFWColorSchemeList = @[
                [FWColorSchemeModel colorSchemeWithGuid:@"default"
                                         youngFillColor:[UIColor colorWithRed:200.0f / 255.0f green:200.0f / 255.0f blue:200.0f / 255.0f alpha:1.0]
                                        mediumFillColor:[UIColor colorWithRed:150.0f / 255.0f green:150.0f / 255.0f blue:150.0f / 255.0f alpha:1.0]
                                           oldFillColor:[UIColor colorWithRed:100.0f / 255.0f green:100.0f / 255.0f blue:100.0f / 255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color1" youngFillColor:[UIColor colorWithRed:228.0f / 255.0f green:144.0f / 255.0f blue:63.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color2" youngFillColor:[UIColor colorWithRed:228.0f / 255.0f green:191.0f / 255.0f blue:63.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color3" youngFillColor:[UIColor colorWithRed:200.0f / 255.0f green:228.0f / 255.0f blue:63.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color4" youngFillColor:[UIColor colorWithRed:63.0f / 255.0f green:212.0f / 255.0f blue:228.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color5" youngFillColor:[UIColor colorWithRed:63.0f / 255.0f green:166.0f / 255.0f blue:228.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color6" youngFillColor:[UIColor colorWithRed:187.0f / 255.0f green:112.0f / 255.0f blue:233.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color7" youngFillColor:[UIColor colorWithRed:229.0f / 255.0f green:117.0f / 255.0f blue:214.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color8" youngFillColor:[UIColor colorWithRed:229.0f / 255.0f green:117.0f / 255.0f blue:174.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil],
                [FWColorSchemeModel colorSchemeWithGuid:@"color9" youngFillColor:[UIColor colorWithRed:229.0f / 255.0f green:113.0f / 255.0f blue:132.0f / 255.0f alpha:1.0] mediumFillColor:nil oldFillColor:nil]
        ];
    }
    return kFWColorSchemeList;
}

@end