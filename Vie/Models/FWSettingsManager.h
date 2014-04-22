//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorScheme;
@class FWBoardSize;

@interface FWSettingsManager : NSObject

+ (FWColorScheme *)getUserColorScheme;
+ (void)saveUserColorScheme:(FWColorScheme *)colorScheme;

+ (FWBoardSize *)getUserBoardSize;
+ (void)saveUserBoardSize:(FWBoardSize *)boardSize;

@end