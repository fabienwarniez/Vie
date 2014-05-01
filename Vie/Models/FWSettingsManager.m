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

static NSString * const kUserSavedGamesKey = @"saved_games";
static NSString * const kUserSavedGameDictionaryNameKey = @"name";
static NSString * const kUserSavedGameDictionaryNumberOfColumnsKey = @"columns";
static NSString * const kUserSavedGameDictionaryNumberOfRowsKey = @"rows";
static NSString * const kUserSavedGameDictionaryCellsKey = @"cells";

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

#pragma mark - Saved Games

+ (NSArray *)getUserSavedGames
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfGames = [userDefaults arrayForKey:kUserSavedGamesKey];

    NSMutableArray *resultArray = nil;
    if (arrayOfGames != nil)
    {
        resultArray = [NSMutableArray array];
        for (NSDictionary *gameDictionary in arrayOfGames)
        {
            FWSavedGame *savedGame = [FWSettingsManager deserializeSavedGame:gameDictionary];
            [resultArray addObject:savedGame];
        }
    }

    return [resultArray copy];
}

+ (void)setUserSavedGames:(NSArray *)savedGames
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *serializedArray = [NSMutableArray arrayWithCapacity:[savedGames count]];
    for (FWSavedGame *savedGame in savedGames)
    {
        NSDictionary *serializedGame = [FWSettingsManager serializeSavedGame:savedGame];
        [serializedArray addObject:serializedGame];
    }

    [userDefaults setObject:serializedArray forKey:kUserSavedGamesKey];
}

+ (void)addUserSavedGame:(FWSavedGame *)savedGame
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfGames = [userDefaults arrayForKey:kUserSavedGamesKey];

    NSMutableArray *resultArray = nil;
    if (arrayOfGames == nil)
    {
        resultArray = [NSMutableArray array];
    }
    else
    {
        resultArray = [arrayOfGames mutableCopy];
    }

    NSDictionary *serializedGame = [FWSettingsManager serializeSavedGame:savedGame];
    [resultArray addObject:serializedGame];

    [userDefaults setObject:resultArray forKey:kUserSavedGamesKey];
}

+ (NSDictionary *)serializeSavedGame:(FWSavedGame *)savedGame
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:savedGame.name forKey:kUserSavedGameDictionaryNameKey];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:savedGame.boardSize.numberOfColumns] forKey:kUserSavedGameDictionaryNumberOfColumnsKey];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:savedGame.boardSize.numberOfRows] forKey:kUserSavedGameDictionaryNumberOfRowsKey];

    NSMutableArray *serializedCells = [NSMutableArray array];
    for (FWCellModel *cell in savedGame.liveCells)
    {
        NSNumber *cellIndex = [NSNumber numberWithUnsignedInteger:cell.column + cell.row * savedGame.boardSize.numberOfColumns];
        [serializedCells addObject:cellIndex];
    }

    [dictionary setObject:[serializedCells copy] forKey:kUserSavedGameDictionaryCellsKey];

    return dictionary;
}

+ (FWSavedGame *)deserializeSavedGame:(NSDictionary *)gameDictionary
{
    NSString *name = [gameDictionary objectForKey:kUserSavedGameDictionaryNameKey];
    NSNumber *numberOfColumnsObject = [gameDictionary objectForKey:kUserSavedGameDictionaryNumberOfColumnsKey];
    NSNumber *numberOfRowsObject = [gameDictionary objectForKey:kUserSavedGameDictionaryNumberOfRowsKey];
    NSArray *cells = [gameDictionary objectForKey:kUserSavedGameDictionaryCellsKey];

    NSUInteger numberOfColumns = [numberOfColumnsObject unsignedIntegerValue];
    NSUInteger numberOfRows = [numberOfRowsObject unsignedIntegerValue];

    FWBoardSizeModel *boardSize = [FWBoardSizeModel boardSizeWithName:nil
                                                      numberOfColumns:numberOfColumns
                                                         numberOfRows:numberOfRows];

    NSMutableArray *deserializedCells = [NSMutableArray array];
    for (NSNumber *liveCellIndexObject in cells)
    {
        NSUInteger liveCellIndex = [liveCellIndexObject unsignedIntegerValue];
        NSUInteger column = liveCellIndex % numberOfColumns;
        NSUInteger row = liveCellIndex / numberOfRows;
        FWCellModel *cellModel = [FWCellModel cellWithAlive:YES column:column row:row];
        [deserializedCells addObject:cellModel];
    }

    return [FWSavedGame gameWithName:name boardSize:boardSize liveCells:[deserializedCells copy]];
}

@end