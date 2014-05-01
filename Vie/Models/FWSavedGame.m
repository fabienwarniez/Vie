//
// Created by Fabien Warniez on 2014-05-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGame.h"
#import "FWBoardSizeModel.h"

@implementation FWSavedGame

- (instancetype)initWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells
{
    self = [super init];
    if (self)
    {
        _name = name;
        _boardSize = boardSize;
        _liveCells = liveCells;
    }
    return self;
}

+ (instancetype)gameWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells
{
    return [[self alloc] initWithName:name boardSize:boardSize liveCells:liveCells];
}

@end