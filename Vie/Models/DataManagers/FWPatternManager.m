//
// Created by Fabien Warniez on 2015-03-03.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWPatternManager.h"
#import "FWPatternModel.h"

static NSString * const kFWPatternEntityName = @"Pattern";

@implementation FWPatternManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self)
    {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (FWPatternModel *)createPatternModel
{
    FWPatternModel *cellPatternModel = [NSEntityDescription insertNewObjectForEntityForName:kFWPatternEntityName inManagedObjectContext:self.managedObjectContext];

    return cellPatternModel;
}

- (NSArray *)allPatterns
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFWPatternEntityName];
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return result;
}

- (NSUInteger)patternCount
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFWPatternEntityName];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

@end
