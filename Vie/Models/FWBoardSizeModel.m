//
// Created by Fabien Warniez on 2014-04-09.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardSizeModel.h"

@implementation FWBoardSizeModel

- (instancetype)initWithName:(NSString *)name numberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows
{
    self = [super init];
    if (self)
    {
        _name = name;
        _numberOfColumns = numberOfColumns;
        _numberOfRows = numberOfRows;
    }
    return self;
}

+ (instancetype)boardSizeWithName:(NSString *)name numberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows
{
    return [[self alloc] initWithName:name numberOfColumns:numberOfColumns numberOfRows:numberOfRows];
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

+ (NSArray *)boardSizes
{
    return @[
            [FWBoardSizeModel boardSizeWithName:NSLocalizedString(@"board_size_small", @"Small") numberOfColumns:32 numberOfRows:48],
            [FWBoardSizeModel boardSizeWithName:NSLocalizedString(@"board_size_medium", @"Medium") numberOfColumns:48 numberOfRows:72],
            [FWBoardSizeModel boardSizeWithName:NSLocalizedString(@"board_size_large", @"Large") numberOfColumns:64 numberOfRows:96]
    ];
}

@end