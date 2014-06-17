//
// Created by Fabien Warniez on 2014-06-16.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternLoader.h"
#import "FWCellPatternModel.h"
#import "FWBoardSizeModel.h"
#import "FWCellModel.h"

@interface FWCellPatternLoader ()

@property (nonatomic, strong) NSArray *patternList;
@property (nonatomic, strong) NSArray *fileLines;

@end

@implementation FWCellPatternLoader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _patternList = [NSArray array];
        _fileLines = nil;
    }
    return self;
}

- (NSArray *)cellPatternsInRange:(NSRange)range
{
    NSRange alreadyParsedPatternRange = NSIntersectionRange(range, NSMakeRange(0, [self.patternList count]));
    NSArray *alreadyParsedPatterns = [self.patternList subarrayWithRange:alreadyParsedPatternRange];

    if (alreadyParsedPatternRange.length == range.length)
    {
        return alreadyParsedPatterns;
    }
    else
    {
        [self loadFileIfNeeded];

        NSMutableArray *newlyParsedPatterns = [NSMutableArray array];
        NSUInteger lineIndexStart = alreadyParsedPatternRange.location + alreadyParsedPatternRange.length;
        NSUInteger lineIndexEnd = range.location + range.length;

        for (NSUInteger lineIndex = lineIndexStart; lineIndex < lineIndexEnd; ++lineIndex)
        {
            NSString *line = self.fileLines[lineIndex];

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
                    cellPatternModel.liveCells = [FWCellPatternLoader cellMatrixFromRLEString:data];
                    [newlyParsedPatterns addObject:cellPatternModel];
                }
                else
                {
                    continue;
                }
            }
        }

        self.patternList = [self.patternList arrayByAddingObjectsFromArray:newlyParsedPatterns];

        return [self.patternList subarrayWithRange:range];
    }
}

- (NSUInteger)numberOfPatterns
{
    [self loadFileIfNeeded];

    return [self.fileLines count];
}

- (void)loadFileIfNeeded
{
    if (self.fileLines == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"patterns" ofType:@"dat"];
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
        self.fileLines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
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

//+ (NSArray *)cellPatterns
//{
//    if (kFWCellPatternList == nil)
//    {
//        NSMutableArray *patterns = [NSMutableArray array];
//
//        FWCellPatternModel *pattern = [self generatePatternFromArray:
//                @[
//                        @[@1, @1, @1, @0, @1, @0, @0, @0, @1],
//                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
//                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
//                        @[@1, @0, @0, @0, @1, @0, @0, @0, @1],
//                        @[@1, @1, @0, @0, @1, @0, @0, @0, @1],
//                        @[@1, @0, @0, @0, @1, @0, @1, @0, @1],
//                        @[@1, @0, @0, @0, @0, @1, @0, @1, @0]
//                ]
//        ];
//        pattern.name = @"FW";
//        pattern.recommendedPosition = FWPatternPositionCenter | FWPatternPositionMiddle;
//
//        FWCellPatternModel *pattern2 = [self generatePatternFromArray:
//                @[
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0],
//                        @[@0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @1, @1, @0, @0, @0, @0, @1, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @0, @0, @0, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @1, @1, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0]
//                ]
//        ];
//        pattern2.name = @"Gosper's Glider Gun";
//        pattern2.recommendedPosition = FWPatternPositionLeft | FWPatternPositionTop;
//
//        [patterns addObject:pattern];
//        [patterns addObject:pattern2];
//
//        kFWCellPatternList = [patterns copy];
//    }
//
//    return kFWCellPatternList;
//}

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