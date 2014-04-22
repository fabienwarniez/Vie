//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSettingsManager.h"
#import "FWColorScheme.h"
#import "FWBoardSize.h"

static NSString *kUserColorSchemeKey = @"color_scheme";
static NSString *kDefaultColorSchemeGuid = @"default";

static NSString *kUserBoardSizeKey = @"board_size";

@implementation FWSettingsManager

+ (FWColorScheme *)getUserColorScheme
{
    NSArray *colorSchemes = [FWColorScheme colorSchemesFromFile];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorSchemeGuid = [userDefaults stringForKey:kUserColorSchemeKey];

    FWColorScheme *userColorScheme = [FWColorScheme colorSchemeFromGuid:colorSchemeGuid inArray:colorSchemes];

    if (userColorScheme == nil)
    {
        colorSchemeGuid = kDefaultColorSchemeGuid;
        [userDefaults setObject:colorSchemeGuid forKey:kUserColorSchemeKey];
        userColorScheme = [FWColorScheme colorSchemeFromGuid:kDefaultColorSchemeGuid inArray:colorSchemes];
    }

    return userColorScheme;
}

+ (void)saveUserColorScheme:(FWColorScheme *)colorScheme
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:colorScheme.guid forKey:kUserColorSchemeKey];
}

+ (FWBoardSize *)getUserBoardSize
{
    return [FWBoardSize boardSizeWithNumberOfColumns:64 numberOfRows:96];
}

+ (void)saveUserBoardSize:(FWBoardSize *)boardSize
{
}

@end