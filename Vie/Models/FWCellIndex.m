//
// Created by Fabien Warniez on 2014-03-30.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellIndex.h"

@implementation FWCellIndex

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row
{
    self = [super init];
    if (self)
    {
        _column = column;
        _row = row;
    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]])
    {
        return NO;
    }

    FWCellIndex *otherCellIndex = other;

    return self.column == otherCellIndex.column && self.row == otherCellIndex.row;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result = prime * result + self.column;
    result = prime * result + self.row;

    return result;
}

- (id)copyWithZone:(NSZone *)zone
{
    FWCellIndex *copy = [[[self class] allocWithZone:zone] init];

    if (copy)
    {
        copy.column = self.column;
        copy.row = self.row;
    }

    return copy;
}

@end
