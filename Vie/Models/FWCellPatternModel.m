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
        _recommendedPosition = FWPatternPositionLeft | FWPatternPositionTop;
    }

    return self;
}

+ (instancetype)cellPatternWithName:(NSString *)name liveCells:(NSArray *)liveCells boardSize:(FWBoardSizeModel *)boardSize
{
    return [[self alloc] initWithName:name liveCells:liveCells boardSize:boardSize];
}

+ (NSArray *)cellPatternsFromFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"patterns" ofType:@"dat"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *patterns = [NSMutableArray array];

    for (NSString *line in lines)
    {
        NSArray *components = [line componentsSeparatedByString:@"|"];
        if ([components count] != 6)
        {
            NSLog(@"Entry badly formatted.");
            continue;
        }
        else
        {
            FWCellPatternModel *cellPatternModel = [[FWCellPatternModel alloc] init];
            cellPatternModel.recommendedPosition = FWPatternPositionCenter | FWPatternPositionMiddle;
            cellPatternModel.fileName = components[0];
            cellPatternModel.format = components[1];
            cellPatternModel.name = components[2];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *numberOfColumns = [numberFormatter numberFromString:components[3]];
            NSNumber *numberOfRows = [numberFormatter numberFromString:components[4]];
            cellPatternModel.boardSize = [FWBoardSizeModel
                    boardSizeWithName:nil
                      numberOfColumns:[numberOfColumns unsignedIntegerValue]
                         numberOfRows:[numberOfRows unsignedIntegerValue]
            ];
            NSString *data = components[5];

            if ([cellPatternModel.format isEqualToString:@"rle"])
            {
                cellPatternModel.liveCells = [FWCellPatternModel cellMatrixFromRLEString:data];
                [patterns addObject:cellPatternModel];
            }
            else
            {
                continue;
            }
        }
    }

    return patterns;
}

+ (NSArray *)cellMatrixFromRLEString:(NSString *)data
{
    NSScanner *scanner = [NSScanner scannerWithString:data];

    NSMutableArray *liveCells = [NSMutableArray array];
    NSUInteger columnIndex = 0;
    NSUInteger rowIndex = 0;

    while (![scanner isAtEnd])
    {
        NSInteger numberOfOccurences;
        if (![scanner scanInteger:&numberOfOccurences])
        {
            numberOfOccurences = 1;
        }

        NSString *nextCharacter = [data substringWithRange:NSMakeRange([scanner scanLocation], 1)];
        if ([nextCharacter isEqualToString:@"!"]) // end of file
        {
            break;
        }
        else if ([nextCharacter isEqualToString:@"$"]) // line end
        {
            columnIndex = 0;
            rowIndex++;
        }
        else if ([nextCharacter isEqualToString:@"b"]) // dead cell
        {
            columnIndex += numberOfOccurences;
        }
        else if ([nextCharacter isEqualToString:@"o"]) // live cell
        {
            for (NSUInteger i = 0; i < numberOfOccurences; i++)
            {
                FWCellModel *cellModel = [FWCellModel cellWithAlive:YES column:columnIndex row:rowIndex];
                columnIndex++;
                [liveCells addObject:cellModel];
            }
        }
        [scanner setScanLocation:[scanner scanLocation] + 1];
    }

    return liveCells;
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
        pattern.recommendedPosition = FWPatternPositionCenter | FWPatternPositionMiddle;

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
        pattern2.recommendedPosition = FWPatternPositionLeft | FWPatternPositionTop;

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