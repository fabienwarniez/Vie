//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardSizeModel;

@interface FWCellPatternModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *liveCells;

- (instancetype)initWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize;
+ (instancetype)cellPatternWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize;

+ (NSArray *)cellPatterns;

@end