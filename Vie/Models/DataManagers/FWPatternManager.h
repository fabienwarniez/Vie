//
// Created by Fabien Warniez on 2015-03-03.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class NSManagedObjectContext;
@class FWPatternModel;

@interface FWPatternManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (FWPatternModel *)createPatternModel;
- (NSArray *)allPatterns;
- (NSUInteger)patternCount;

@end