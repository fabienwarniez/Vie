//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWGameBoardSizeModel;

@interface FWSettingsManager : NSObject

+ (FWColorSchemeModel *)getUserColorScheme;
+ (void)saveUserColorScheme:(FWColorSchemeModel *)colorScheme;

+ (FWGameBoardSizeModel *)getUserBoardSize;
+ (void)saveUserBoardSize:(FWGameBoardSizeModel *)boardSize;

@end