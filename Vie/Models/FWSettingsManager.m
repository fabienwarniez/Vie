//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSettingsManager.h"
#import "FWColorSchemeModel.h"
#import "FWGameBoardSizeModel.h"

static NSString *kUserColorSchemeKey = @"color_scheme";
static NSString *kDefaultColorSchemeGuid = @"default";

static NSString *kUserBoardSizeKey = @"board_size";

@implementation FWSettingsManager

+ (FWColorSchemeModel *)getUserColorScheme
{
    NSArray *colorSchemes = [FWColorSchemeModel colorSchemesFromFile];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorSchemeGuid = [userDefaults stringForKey:kUserColorSchemeKey];

    FWColorSchemeModel *userColorScheme = [FWColorSchemeModel colorSchemeFromGuid:colorSchemeGuid inArray:colorSchemes];

    if (userColorScheme == nil)
    {
        colorSchemeGuid = kDefaultColorSchemeGuid;
        [userDefaults setObject:colorSchemeGuid forKey:kUserColorSchemeKey];
        userColorScheme = [FWColorSchemeModel colorSchemeFromGuid:kDefaultColorSchemeGuid inArray:colorSchemes];
    }

    return userColorScheme;
}

+ (void)saveUserColorScheme:(FWColorSchemeModel *)colorScheme
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:colorScheme.guid forKey:kUserColorSchemeKey];
}

+ (FWGameBoardSizeModel *)getUserBoardSize
{
    return [FWGameBoardSizeModel boardSizeWithNumberOfColumns:64 numberOfRows:96];
}

+ (void)saveUserBoardSize:(FWGameBoardSizeModel *)boardSize
{
}

@end