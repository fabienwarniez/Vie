//
// Created by Fabien Warniez on 2014-04-09.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardSizeModel.h"

static NSArray *kFWBoardSizeList = nil;

@implementation FWBoardSizeModel

- (instancetype)initWithNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows
{
    self = [super init];
    if (self)
    {
        _numberOfColumns = numberOfColumns;
        _numberOfRows = numberOfRows;
    }
    return self;
}

+ (instancetype)boardSizeWithNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows
{
    return [[self alloc] initWithNumberOfColumns:numberOfColumns numberOfRows:numberOfRows];
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    else if (!other || ![[other class] isEqual:[self class]])
    {
        return NO;
    }
    else
    {
        return [self isEqualToBoardSize:other];
    }
}

- (BOOL)isEqualToBoardSize:(FWBoardSizeModel *)otherBoardSize
{
    return self.numberOfColumns == otherBoardSize.numberOfColumns && self.numberOfRows == otherBoardSize.numberOfRows;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger hash = 1;
    hash += prime * hash + self.numberOfColumns;
    hash += prime * hash + self.numberOfRows;
    return hash;
}

- (BOOL)isGreaterOrEqualToBoardSize:(FWBoardSizeModel *)other
{
    return self.numberOfColumns >= other.numberOfColumns && self.numberOfRows >= other.numberOfRows;
}

- (BOOL)isSmallerOrEqualToBoardSize:(FWBoardSizeModel *)other
{
    return self.numberOfColumns <= other.numberOfColumns && self.numberOfRows <= other.numberOfRows;
}

+ (NSArray *)boardSizes
{
    if (kFWBoardSizeList == nil)
    {
        kFWBoardSizeList = @[
                [FWBoardSizeModel boardSizeWithNumberOfColumns:6 numberOfRows:10],
                [FWBoardSizeModel boardSizeWithNumberOfColumns:30 numberOfRows:40],
                [FWBoardSizeModel boardSizeWithNumberOfColumns:45 numberOfRows:60],
                [FWBoardSizeModel boardSizeWithNumberOfColumns:60 numberOfRows:80],
                [FWBoardSizeModel boardSizeWithNumberOfColumns:90 numberOfRows:120]
        ];
    }
    return kFWBoardSizeList;
}

+ (instancetype)defaultBoardSize
{
    return [[FWBoardSizeModel boardSizes] firstObject];
}

@end