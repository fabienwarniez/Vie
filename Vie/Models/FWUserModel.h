//
// Created by Fabien Warniez on 2014-04-22.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWGameBoardSizeModel;

@interface FWUserModel : NSObject

@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, strong) FWGameBoardSizeModel *gameBoardSize;

@end