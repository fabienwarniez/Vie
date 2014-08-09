//
// Created by Fabien Warniez on 2014-04-22.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWUserModel.h"
#import "FWColorSchemeModel.h"
#import "FWSettingsManager.h"
#import "FWBoardSizeModel.h"
#import "FWSavedGame.h"

@implementation FWUserModel
{
    FWColorSchemeModel *_colorScheme;
    FWBoardSizeModel *_gameBoardSize;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _colorScheme = nil;
        _gameBoardSize = nil;
    }
    return self;
}

+ (instancetype)sharedUserModel
{
    static FWUserModel *sharedUserModel = nil;
    @synchronized(self)
    {
        if (sharedUserModel == nil)
        {
            sharedUserModel = [[self alloc] init];
        }
    }
    return sharedUserModel;
}

- (FWColorSchemeModel *)colorScheme
{
    if (_colorScheme == nil)
    {
        NSArray *colorSchemes = [FWColorSchemeModel colors];
        NSString *colorSchemeGuid = [FWSettingsManager getUserColorSchemeGuid];

        FWColorSchemeModel *userColorScheme = [FWColorSchemeModel colorSchemeFromGuid:colorSchemeGuid inArray:colorSchemes];

        if (userColorScheme == nil) // guid retrieved is either nil or invalid, setting back to default value
        {
            userColorScheme = [colorSchemes firstObject]; // first object is the default
            [FWSettingsManager saveUserColorSchemeGuid:userColorScheme.guid];
        }

        _colorScheme = userColorScheme;
    }

    return _colorScheme;
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    [FWSettingsManager saveUserColorSchemeGuid:colorScheme.guid];
}

- (FWBoardSizeModel *)gameBoardSize
{
    if (_gameBoardSize == nil)
    {
        FWBoardSizeModel *userGameBoardSize = [FWSettingsManager getUserBoardSize];

        NSAssert(userGameBoardSize != nil, @"Game board size object should never be nil.");

        if (userGameBoardSize.numberOfColumns == 0 || userGameBoardSize.numberOfRows == 0)
        {
            userGameBoardSize = [FWBoardSizeModel defaultBoardSize];

            [FWSettingsManager saveUserBoardSize:userGameBoardSize];
        }
        _gameBoardSize = userGameBoardSize;
    }

    return _gameBoardSize;
}

- (void)setGameBoardSize:(FWBoardSizeModel *)gameBoardSize
{
    _gameBoardSize = gameBoardSize;
    [FWSettingsManager saveUserBoardSize:gameBoardSize];
}

- (NSArray *)savedGames
{
    NSArray *savedGames = [FWSettingsManager getUserSavedGames];
    if (savedGames == nil)
    {
        savedGames = [NSArray array];
        [FWSettingsManager setUserSavedGames:savedGames];
    }
    return savedGames;
}

- (void)addSavedGame:(FWSavedGame *)savedGame
{
    [FWSettingsManager addUserSavedGame:savedGame];
}

- (void)editSavedGame:(FWSavedGame *)savedGame
{
    [FWSettingsManager editUserSavedGame:savedGame];
}

@end