//
// Created by Fabien Warniez on 2014-06-16.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWPatternLoader : NSObject

- (NSArray *)patternsInRange:(NSRange)range;
- (NSUInteger)patternCount;

@end