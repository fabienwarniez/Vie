//
// Created by Fabien Warniez on 2014-04-22.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWUserModel.h"
#import "FWColorSchemeModel.h"
#import "FWSettingsManager.h"
#import "FWBoardSizeModel.h"
#import "FWGameSpeed.h"

@implementation FWUserModel
{
    FWColorSchemeModel *_colorScheme;
    FWBoardSizeModel *_boardSize;
    NSUInteger _gameSpeed;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _colorScheme = nil;
        _boardSize = nil;
        _gameSpeed = 0;
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
            [FWSettingsManager setUserColorSchemeGuid:userColorScheme.guid];
        }

        _colorScheme = userColorScheme;
    }

    return _colorScheme;
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    [FWSettingsManager setUserColorSchemeGuid:colorScheme.guid];
}

- (FWBoardSizeModel *)boardSize
{
    if (_boardSize == nil)
    {
        FWBoardSizeModel *userGameBoardSize = [FWSettingsManager getUserBoardSize];

        NSAssert(userGameBoardSize != nil, @"Game board size object should never be nil.");

        if (userGameBoardSize.numberOfColumns == 0 || userGameBoardSize.numberOfRows == 0)
        {
            userGameBoardSize = [FWBoardSizeModel defaultBoardSize];

            [FWSettingsManager setUserBoardSize:userGameBoardSize];
        }
        _boardSize = userGameBoardSize;
    }

    return _boardSize;
}

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;
    [FWSettingsManager setUserBoardSize:boardSize];
}

- (NSUInteger)gameSpeed
{
    if (_gameSpeed == 0)
    {
        NSUInteger userGameSpeed = [FWSettingsManager getUserGameSpeed];

        if (userGameSpeed == 0)
        {
            userGameSpeed = [FWGameSpeed defaultGameSpeed];

            [FWSettingsManager setUserGameSpeed:userGameSpeed];
        }
        _gameSpeed = userGameSpeed;
    }

    return _gameSpeed;
}

- (void)setGameSpeed:(NSUInteger)gameSpeed
{
    _gameSpeed = gameSpeed;
    [FWSettingsManager setUserGameSpeed:gameSpeed];
}

@end