//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSettingsManager.h"
#import "FWBoardSizeModel.h"

static NSString * const kFWUserColorSchemeKey = @"color_scheme";
static NSString * const kFWUserBoardSizeColumnsKey = @"board_size_columns";
static NSString * const kFWUserBoardSizeRowsKey = @"board_size_rows";
static NSString * const kFWUserGameSpeedKey = @"game_speed";
static NSString * const kFWDataUpdate1Key = @"data_update_1";

@implementation FWSettingsManager

#pragma mark - Color Scheme

+ (NSString *)getUserColorSchemeGuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorSchemeGuid = [userDefaults stringForKey:kFWUserColorSchemeKey];

    return colorSchemeGuid;
}

+ (void)setUserColorSchemeGuid:(NSString *)colorSchemeGuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:colorSchemeGuid forKey:kFWUserColorSchemeKey];
}

#pragma mark - Board Size

+ (FWBoardSizeModel *)getUserBoardSize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberOfColumns = [userDefaults integerForKey:kFWUserBoardSizeColumnsKey];
    NSInteger numberOfRows = [userDefaults integerForKey:kFWUserBoardSizeRowsKey];

    // ensure values returned are not negative because we need to cast them to unsigned
    numberOfColumns = numberOfColumns >= 0 ? numberOfColumns : 0;
    numberOfRows = numberOfRows >= 0 ? numberOfRows : 0;

    return [FWBoardSizeModel boardSizeWithNumberOfColumns:(NSUInteger) numberOfColumns numberOfRows:(NSUInteger) numberOfRows];
}

+ (void)setUserBoardSize:(FWBoardSizeModel *)boardSize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:boardSize.numberOfColumns forKey:kFWUserBoardSizeColumnsKey];
    [userDefaults setInteger:boardSize.numberOfRows forKey:kFWUserBoardSizeRowsKey];
}

#pragma mark - Game Speed

+ (NSUInteger)getUserGameSpeed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger gameSpeed = [userDefaults integerForKey:kFWUserGameSpeedKey];

    return (NSUInteger) gameSpeed;
}

+ (void)setUserGameSpeed:(NSUInteger)gameSpeed
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:gameSpeed forKey:kFWUserGameSpeedKey];
}

#pragma mark - Pattern Updates

+ (BOOL)getDataUpdate1Status
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kFWDataUpdate1Key];
}

+ (void)setDataUpdate1Status:(BOOL)status
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:status forKey:kFWDataUpdate1Key];
}

@end