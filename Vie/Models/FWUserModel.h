//
// Created by Fabien Warniez on 2014-04-22.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWSavedGame;

@interface FWUserModel : NSObject

@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong, readonly) NSArray *savedGames;

+ (instancetype)sharedUserModel;

- (void)saveGameWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells;
- (void)editSavedGame:(FWSavedGame *)savedGame;

@end