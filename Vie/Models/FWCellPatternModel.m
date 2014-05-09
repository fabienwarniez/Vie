//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternModel.h"
#import "FWBoardSizeModel.h"
#import "FWCellModel.h"

static NSArray *kFWCellPatternList = nil;

@implementation FWCellPatternModel

- (instancetype)initWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize
{
    self = [super init];
    if (self)
    {
        _name = name;
        _liveCells = liveCells;
        _boardSize = boardSize;
    }

    return self;
}

+ (instancetype)cellPatternWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize
{
    return [[self alloc] initWithName:name liveCells:liveCells boardSize:boardSize];
}

+ (NSArray *)cellPatterns
{
    if (kFWCellPatternList == nil)
    {
        NSMutableArray *patterns = [NSMutableArray array];

        FWCellPatternModel *pattern = [self generatePatternFromArray:
                @[
                        @[@1, @1, @1, @0, @1, @0, @0, @0, @1],
                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
                        @[@1, @1, @0, @0, @1, @0, @0, @0, @1],
                        @[@1, @0, @0, @0, @1, @0, @1, @0, @1],
                        @[@1, @0, @0, @0, @0, @1, @0, @1, @0]
                ]
        ];
        pattern.name = @"FW";

        FWCellPatternModel *pattern2 = [self generatePatternFromArray:
                @[
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0],
                        @[@0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @1, @1, @0, @0, @0, @0, @1, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0]
                ]
        ];
        pattern2.name = @"Gosper's Glider Gun";

        [patterns addObject:pattern];
        [patterns addObject:pattern2];

        kFWCellPatternList = [patterns copy];
    }

    return kFWCellPatternList;
}

+ (FWCellPatternModel *)generatePatternFromArray:(NSArray *)simpleArray
{
    NSMutableArray *cells = [NSMutableArray array];
    FWBoardSizeModel *boardSize = [[FWBoardSizeModel alloc] initWithName:nil numberOfColumns:[simpleArray[0] count] numberOfRows:[simpleArray count]];

    for (NSUInteger rowIndex = 0; rowIndex < [simpleArray count]; rowIndex++)
    {
        NSArray *simpleRow = simpleArray[rowIndex];
        for (NSUInteger columnIndex = 0; columnIndex < [simpleRow count]; columnIndex++)
        {
            if ([simpleRow[columnIndex] unsignedIntegerValue] == 1)
            {
                FWCellModel *newCell = [[FWCellModel alloc] init];
                newCell.alive = YES;
                newCell.column = columnIndex;
                newCell.row = rowIndex;

                [cells addObject:newCell];
            }
        }
    }

    return [FWCellPatternModel cellPatternWithName:nil liveCells:cells boardSize:boardSize];
}

@end