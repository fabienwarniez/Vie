//
// Created by Fabien Warniez on 2015-03-03.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWPatternManager.h"
#import "FWPatternModel.h"

static NSString * const kFWPatternEntityName = @"Pattern";

@interface FWPatternManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

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

- (NSArray *)patternsForSearchString:(NSString *)searchString onlyFavourites:(BOOL)onlyFavourites
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFWPatternEntityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    if (searchString != nil && [searchString length] > 0 && onlyFavourites) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@ AND favourited == %@", searchString, @(onlyFavourites)];
        [fetchRequest setPredicate:predicate];
    } else if (onlyFavourites) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favourited == %@", @(onlyFavourites)];
        [fetchRequest setPredicate:predicate];
    } else if (searchString != nil && [searchString length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
        [fetchRequest setPredicate:predicate];
    }

    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (NSUInteger)patternCount
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFWPatternEntityName];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

@end
