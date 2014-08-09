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
static NSString * const kUserSavedGameDictionaryUuidKey = @"uuid";
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

+ (void)editUserSavedGame:(FWSavedGame *)savedGame
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfGames = [userDefaults arrayForKey:kUserSavedGamesKey];

    NSAssert(arrayOfGames != nil, @"Trying to edit a game when there are no games saved.");

    NSMutableArray *resultArray = [arrayOfGames mutableCopy];

    NSUInteger searchedGameIndex = NSNotFound;
    for (NSDictionary *serializedGameIterator in arrayOfGames)
    {
        if ([serializedGameIterator[kUserSavedGameDictionaryUuidKey] isEqualToString:savedGame.uuid])
        {
            searchedGameIndex = [arrayOfGames indexOfObject:serializedGameIterator];
        }
    }

    NSAssert(searchedGameIndex != NSNotFound, @"Saved game not found, but should exist.");

    NSDictionary *serializedGame = [FWSettingsManager serializeSavedGame:savedGame];

    resultArray[searchedGameIndex] = serializedGame;

    [userDefaults setObject:resultArray forKey:kUserSavedGamesKey];
}

+ (void)deleteUserSavedGame:(FWSavedGame *)savedGame
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfGames = [userDefaults arrayForKey:kUserSavedGamesKey];

    NSAssert(arrayOfGames != nil, @"Trying to delete a game when there are no games saved.");

    NSMutableArray *resultArray = [arrayOfGames mutableCopy];

    NSUInteger searchedGameIndex = NSNotFound;
    for (NSDictionary *serializedGameIterator in arrayOfGames)
    {
        if ([serializedGameIterator[kUserSavedGameDictionaryUuidKey] isEqualToString:savedGame.uuid])
        {
            searchedGameIndex = [arrayOfGames indexOfObject:serializedGameIterator];
        }
    }

    NSAssert(searchedGameIndex != NSNotFound, @"Saved game not found, but should exist.");

    [resultArray removeObjectAtIndex:searchedGameIndex];

    [userDefaults setObject:resultArray forKey:kUserSavedGamesKey];
}

+ (NSDictionary *)serializeSavedGame:(FWSavedGame *)savedGame
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    dictionary[kUserSavedGameDictionaryUuidKey] = savedGame.uuid;
    dictionary[kUserSavedGameDictionaryNameKey] = savedGame.name;
    dictionary[kUserSavedGameDictionaryNumberOfColumnsKey] = @(savedGame.boardSize.numberOfColumns);
    dictionary[kUserSavedGameDictionaryNumberOfRowsKey] = @(savedGame.boardSize.numberOfRows);

    NSMutableArray *serializedCells = [NSMutableArray array];
    for (FWCellModel *cell in savedGame.liveCells)
    {
        NSNumber *cellIndex = @(cell.column * savedGame.boardSize.numberOfRows + cell.row);
        [serializedCells addObject:cellIndex];
    }

    dictionary[kUserSavedGameDictionaryCellsKey] = [serializedCells copy];

    return dictionary;
}

+ (FWSavedGame *)deserializeSavedGame:(NSDictionary *)gameDictionary
{
    NSString *uuid = gameDictionary[kUserSavedGameDictionaryUuidKey];
    NSString *name = gameDictionary[kUserSavedGameDictionaryNameKey];
    NSNumber *numberOfColumnsObject = gameDictionary[kUserSavedGameDictionaryNumberOfColumnsKey];
    NSNumber *numberOfRowsObject = gameDictionary[kUserSavedGameDictionaryNumberOfRowsKey];
    NSArray *cells = gameDictionary[kUserSavedGameDictionaryCellsKey];

    NSUInteger numberOfColumns = [numberOfColumnsObject unsignedIntegerValue];
    NSUInteger numberOfRows = [numberOfRowsObject unsignedIntegerValue];

    FWBoardSizeModel *boardSize = [FWBoardSizeModel boardSizeWithName:nil
                                                      numberOfColumns:numberOfColumns
                                                         numberOfRows:numberOfRows];

    NSMutableArray *deserializedCells = [NSMutableArray array];
    for (NSNumber *liveCellIndexObject in cells)
    {
        NSUInteger liveCellIndex = [liveCellIndexObject unsignedIntegerValue];
        NSUInteger column = liveCellIndex / numberOfRows;
        NSUInteger row = liveCellIndex % numberOfRows;
        FWCellModel *cellModel = [FWCellModel cellWithAlive:YES column:column row:row];
        [deserializedCells addObject:cellModel];
    }

    return [FWSavedGame gameWithUuid:uuid name:name boardSize:boardSize liveCells:[deserializedCells copy]];
}

@end