//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWSavedGame;

@interface FWSettingsManager : NSObject

+ (NSString *)getUserColorSchemeGuid;
+ (void)saveUserColorSchemeGuid:(NSString *)colorSchemeGuid;

+ (FWBoardSizeModel *)getUserBoardSize;
+ (void)saveUserBoardSize:(FWBoardSizeModel *)boardSize;

@end