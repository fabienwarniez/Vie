//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSettingsManager.h"
#import "FWBoardSizeModel.h"
#import "FWSavedGame.h"
#import "FWCellModel.h"

static NSString * const kUserColorSchemeKey = @"color_scheme";

static NSString * const kUserBoardSizeColumnsKey = @"board_size_columns";
static NSString * const kUserBoardSizeRowsKey = @"board_size_rows";

@implementation FWSettingsManager

#pragma mark - Color Scheme

+ (NSString *)getUserColorSchemeGuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *colorSchemeGuid = [userDefaults stringForKey:kUserColorSchemeKey];

    return colorSchemeGuid;
}

+ (void)saveUserColorSchemeGuid:(NSString *)colorSchemeGuid
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:colorSchemeGuid forKey:kUserColorSchemeKey];
}

#pragma mark - Board Size

+ (FWBoardSizeModel *)getUserBoardSize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberOfColumns = [userDefaults integerForKey:kUserBoardSizeColumnsKey];
    NSInteger numberOfRows = [userDefaults integerForKey:kUserBoardSizeRowsKey];

    // ensure values returned are not negative because we need to cast them to unsigned
    numberOfColumns = numberOfColumns >= 0 ? numberOfColumns : 0;
    numberOfRows = numberOfRows >= 0 ? numberOfRows : 0;

    return [FWBoardSizeModel boardSizeWithName:nil numberOfColumns:(NSUInteger) numberOfColumns numberOfRows:(NSUInteger) numberOfRows];
}

+ (void)saveUserBoardSize:(FWBoardSizeModel *)boardSize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:boardSize.numberOfColumns forKey:kUserBoardSizeColumnsKey];
    [userDefaults setInteger:boardSize.numberOfRows forKey:kUserBoardSizeRowsKey];
}

@end