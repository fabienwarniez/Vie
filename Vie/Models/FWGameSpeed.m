//
// Created by Fabien Warniez on 14-12-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameSpeed.h"

@implementation FWGameSpeed

+ (NSArray *)gameSpeeds
{
    return @[@5, @10, @15];
}

+ (NSUInteger)defaultGameSpeed
{
    return [[FWGameSpeed gameSpeeds][1] unsignedIntegerValue];
}

@end