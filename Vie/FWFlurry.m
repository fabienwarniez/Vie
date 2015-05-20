//
// Created by Fabien Warniez on 2015-05-19.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWFlurry.h"
#import "Flurry.h"

@implementation FWFlurry

+ (void)startSession:(NSString *)string
{
#ifndef DEBUG
    [Flurry startSession:string];
#endif
}

+ (void)logEvent:(NSString *)string timed:(BOOL)timed
{
#ifndef DEBUG
    [Flurry logEvent:string timed:timed];
#endif
}

+ (void)logEvent:(NSString *)string withParameters:(NSDictionary *)parameters
{
#ifndef DEBUG
    [Flurry logEvent:string withParameters:parameters];
#endif
}

+ (void)endTimedEvent:(NSString *)string withParameters:(NSDictionary *)parameters
{
#ifndef DEBUG
    [Flurry endTimedEvent:string withParameters:parameters];
#endif
}

@end