//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellModel.h"

@implementation FWCellModel

- (instancetype)initWithAlive:(BOOL)alive column:(NSUInteger)column row:(NSUInteger)row
{
    self = [super init];
    if (self)
    {
        _alive = alive;
        _column = column;
        _row = row;
        _age = 0;
    }
    return self;
}

+ (instancetype)cellWithAlive:(BOOL)alive column:(NSUInteger)column row:(NSUInteger)row
{
    return [[self alloc] initWithAlive:alive column:column row:row];
}

- (id)copyWithZone:(NSZone *)zone
{
    FWCellModel *copy = [[FWCellModel alloc] init];
    copy.alive = self.alive;
    copy.column = self.column;
    copy.row = self.row;
    copy.age = self.age;

    return copy;
}

@end