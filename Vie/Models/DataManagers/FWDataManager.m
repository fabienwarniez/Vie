//
// Created by Fabien Warniez on 2015-03-03.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWDataManager.h"
#import "FWPatternManager.h"
#import "FWSavedGameManager.h"

@interface FWDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FWDataManager
{
    FWPatternManager *_patternManager;
    FWSavedGameManager *_savedGameManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _managedObjectContext = [self createManagedObjectContext];
    }
    return self;
}

+ (instancetype)sharedDataManager
{
    static FWDataManager *sharedDataManager = nil;
    @synchronized(self)
    {
        if (sharedDataManager == nil)
        {
            sharedDataManager = [[self alloc] init];
        }
    }
    return sharedDataManager;
}

- (FWPatternManager *)patternManager
{
    if (_patternManager == nil) {
        _patternManager = [[FWPatternManager alloc] initWithManagedObjectContext:self.managedObjectContext];
    }

    return _patternManager;
}

- (FWSavedGameManager *)savedGameManager
{
    if (_savedGameManager == nil) {
        _savedGameManager = [[FWSavedGameManager alloc] initWithManagedObjectContext:self.managedObjectContext];
    }

    return _savedGameManager;
}

#pragma mark - Private Methods

- (NSManagedObjectContext *)createManagedObjectContext
{
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Database.sqlite"];

    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:@{NSMigratePersistentStoresAutomaticallyOption: @YES} error:nil];

    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    return managedObjectContext;
}

@end
