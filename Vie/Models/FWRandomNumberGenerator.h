//
// Created by Fabien Warniez on 2014-04-19.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWRandomNumberGenerator : NSObject

+ (NSUInteger)randomUnsignedIntegerBetweenLowerBound:(NSUInteger)lowerBound andHigherBound:(NSUInteger)higherBound;
+ (BOOL)randomBooleanWithPositivePercentageOf:(NSUInteger)percentageOfYes;

@end