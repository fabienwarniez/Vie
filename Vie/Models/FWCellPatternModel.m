//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternModel.h"
#import "FWBoardSizeModel.h"

@implementation FWCellPatternModel

- (instancetype)initWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize
{
    self = [super init];
    if (self)
    {
        _name = name;
        _liveCells = liveCells;
        _boardSize = boardSize;
        _recommendedPosition = FWPatternPositionLeft | FWPatternPositionTop;
    }

    return self;
}

+ (instancetype)cellPatternWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize
{
    return [[self alloc] initWithName:name liveCells:liveCells boardSize:boardSize];
}

@end