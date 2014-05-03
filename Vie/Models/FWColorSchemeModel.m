//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeModel.h"

static NSArray *kFWColorSchemeColorList = nil;

@implementation FWColorSchemeModel

- (instancetype)initWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor
{
    self = [super init];
    if (self)
    {
        _guid = guid;
        _fillColor = fillColor;
    }
    return self;
}

+ (instancetype)colorSchemeWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor
{
    return [[self alloc] initWithGuid:guid fillColor:fillColor];
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
    if (kFWColorSchemeColorList == nil)
    {
        kFWColorSchemeColorList = @[
                [FWColorSchemeModel colorSchemeWithGuid:@"default" fillColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color1" fillColor:[UIColor colorWithRed:228.0f/255.0f green:144.0f/255.0f blue:63.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color2" fillColor:[UIColor colorWithRed:228.0f/255.0f green:191.0f/255.0f blue:63.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color3" fillColor:[UIColor colorWithRed:200.0f/255.0f green:228.0f/255.0f blue:63.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color4" fillColor:[UIColor colorWithRed:63.0f/255.0f green:212.0f/255.0f blue:228.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color5" fillColor:[UIColor colorWithRed:63.0f/255.0f green:166.0f/255.0f blue:228.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color6" fillColor:[UIColor colorWithRed:187.0f/255.0f green:112.0f/255.0f blue:233.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color7" fillColor:[UIColor colorWithRed:229.0f/255.0f green:117.0f/255.0f blue:214.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color8" fillColor:[UIColor colorWithRed:229.0f/255.0f green:117.0f/255.0f blue:174.0f/255.0f alpha:1.0]],
                [FWColorSchemeModel colorSchemeWithGuid:@"color9" fillColor:[UIColor colorWithRed:229.0f/255.0f green:113.0f/255.0f blue:132.0f/255.0f alpha:1.0]]
        ];
    }
    return kFWColorSchemeColorList;
}

@end