//
// Created by Fabien Warniez on 2014-04-21.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWSavedGameModel;

@interface FWSettingsManager : NSObject

+ (NSString *)getUserColorSchemeGuid;
+ (void)setUserColorSchemeGuid:(NSString *)colorSchemeGuid;

+ (FWBoardSizeModel *)getUserBoardSize;
+ (void)setUserBoardSize:(FWBoardSizeModel *)boardSize;

+ (NSUInteger)getUserGameSpeed;
+ (void)setUserGameSpeed:(NSUInteger)gameSpeed;

+ (BOOL)getDataUpdate1Status;
+ (void)setDataUpdate1Status:(BOOL)status;

@end