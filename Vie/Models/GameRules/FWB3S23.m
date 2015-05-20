//
// Created by Fabien Warniez on 2015-05-20.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWB3S23.h"

@implementation FWB3S23

- (BOOL)birthWithNeighbourCount:(NSUInteger)neighbourCount
{
    return neighbourCount == 3;
}

- (BOOL)survivesWithNeighbourCount:(NSUInteger)neighbourCount
{
    return neighbourCount == 2 || neighbourCount == 3;
}

@end
