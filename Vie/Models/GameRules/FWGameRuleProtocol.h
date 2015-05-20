//
// Created by Fabien Warniez on 2015-05-20.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@protocol FWGameRuleProtocol <NSObject>

- (BOOL)birthWithNeighbourCount:(NSUInteger)neighbourCount;
- (BOOL)survivesWithNeighbourCount:(NSUInteger)neighbourCount;

@end
