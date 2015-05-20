//
// Created by Fabien Warniez on 2015-05-19.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@interface FWFlurry : NSObject

+ (void)startSession:(NSString *)string;
+ (void)logEvent:(NSString *)string timed:(BOOL)timed;
+ (void)logEvent:(NSString *)string withParameters:(NSDictionary *)parameters;
+ (void)endTimedEvent:(NSString *)string withParameters:(NSDictionary *)parameters;

@end