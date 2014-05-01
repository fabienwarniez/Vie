//
// Created by Fabien Warniez on 2014-05-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardSizeModel;

@interface FWSavedGame : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *liveCells;

- (instancetype)initWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells;
+ (instancetype)gameWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells;

@end