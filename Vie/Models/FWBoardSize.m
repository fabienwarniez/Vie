//
// Created by Fabien Warniez on 2014-04-09.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardSize.h"

@implementation FWBoardSize

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

@end