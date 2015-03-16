//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWSavedGameManager.h"
#import "FWSavedGameModel.h"

static NSString * const kFWSavedGameEntityName = @"SavedGame";

@interface FWSavedGameManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FWSavedGameManager

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self)
    {
        _managedObjectContext = managedObjectContext;
    }
    return self;
}

- (FWSavedGameModel *)createSavedGameModel
{
    FWSavedGameModel *savedGameModel = [NSEntityDescription insertNewObjectForEntityForName:kFWSavedGameEntityName inManagedObjectContext:self.managedObjectContext];

    return savedGameModel;
}

- (NSArray *)savedGamesForSearchString:(NSString *)searchString
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kFWSavedGameEntityName inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    if (searchString != nil && [searchString length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchString];
        [fetchRequest setPredicate:predicate];
    }

    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (NSUInteger)savedGameCount
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kFWSavedGameEntityName];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

@end
