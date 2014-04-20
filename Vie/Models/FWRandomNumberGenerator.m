//
// Created by Fabien Warniez on 2014-04-19.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWRandomNumberGenerator.h"

@implementation FWRandomNumberGenerator

+ (NSUInteger)randomUnsignedIntegerBetweenLowerBound:(NSUInteger)lowerBound andHigherBound:(NSUInteger)higherBound
{
    return (NSUInteger)lowerBound + arc4random() % (higherBound - lowerBound + 1);
}

+ (BOOL)randomBooleanWithPositivePercentageOf:(NSUInteger)percentageOfYes
{
    return [FWRandomNumberGenerator randomUnsignedIntegerBetweenLowerBound:0 andHigherBound:99] < percentageOfYes;
}

@end