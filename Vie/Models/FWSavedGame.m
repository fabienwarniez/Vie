//
// Created by Fabien Warniez on 2014-05-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGame.h"
#import "FWBoardSizeModel.h"

@implementation FWSavedGame

- (instancetype)initWithUuid:(NSString *)uuid name:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells
{
    self = [super init];
    if (self)
    {
        _uuid = uuid;
        _name = name;
        _boardSize = boardSize;
        _liveCells = liveCells;
    }
    return self;
}

+ (instancetype)gameWithUuid:(NSString *)uuid name:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells
{
    return [[self alloc] initWithUuid:uuid name:name boardSize:boardSize liveCells:liveCells];
}

@end