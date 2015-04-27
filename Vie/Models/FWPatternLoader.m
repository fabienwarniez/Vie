//
// Created by Fabien Warniez on 2014-06-16.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWPatternLoader.h"
#import "FWPatternModel.h"
#import "FWBoardSizeModel.h"
#import "FWPatternManager.h"
#import "FWDataManager.h"

@interface FWPatternLoader ()

@property (nonatomic, strong) NSArray *patternList;
@property (nonatomic, strong) NSArray *fileLines;

@end

@implementation FWPatternLoader

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

- (NSArray *)patternsInRange:(NSRange)range
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
        NSUInteger lineIndexStart;
        if (alreadyParsedPatternRange.length > 0)
        {
            lineIndexStart = alreadyParsedPatternRange.location + alreadyParsedPatternRange.length;
        }
        else
        {
            lineIndexStart = [self.patternList count];
        }
        NSUInteger lineIndexEnd = range.location + range.length;

        NSLog(@"Loading patterns in range %lu to %lu", (unsigned long) lineIndexStart, (unsigned long) lineIndexEnd);

        FWPatternManager *patternManager = [[FWDataManager sharedDataManager] patternManager];

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
                FWPatternModel *cellPatternModel = [patternManager createPatternModel];
                cellPatternModel.fileName = components[0];
                cellPatternModel.format = components[1];
                cellPatternModel.name = components[2];
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber *numberOfColumns = [numberFormatter numberFromString:components[3]];
                NSNumber *numberOfRows = [numberFormatter numberFromString:components[4]];
                cellPatternModel.boardSize = [FWBoardSizeModel boardSizeWithNumberOfColumns:[numberOfColumns unsignedIntegerValue] numberOfRows:[numberOfRows unsignedIntegerValue]];
                cellPatternModel.encodedData = components[5];
                cellPatternModel.favourited = NO;
                [newlyParsedPatterns addObject:cellPatternModel];
            }
        }

        self.patternList = [self.patternList arrayByAddingObjectsFromArray:newlyParsedPatterns];

        return [self.patternList subarrayWithRange:range];
    }
}

- (NSUInteger)patternCount
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

@end
