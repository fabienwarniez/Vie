//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellModel.h"

@implementation FWCellModel

- (id)copyWithZone:(NSZone *)zone
{
    FWCellModel *copy = [[FWCellModel alloc] init];
    copy.alive = self.alive;
    copy.column = self.column;
    copy.row = self.row;

    return copy;
}

@end