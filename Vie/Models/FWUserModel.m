//
// Created by Fabien Warniez on 2014-04-22.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWUserModel.h"
#import "FWColorSchemeModel.h"
#import "FWSettingsManager.h"
#import "FWBoardSizeModel.h"
#import "FWSavedGame.h"

@interface FWUserModel ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FWUserModel
{
    FWColorSchemeModel *_colorScheme;
    FWBoardSizeModel *_boardSize;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _colorScheme = nil;
        _boardSize = nil;
        _managedObjectContext = [self createManagedObjectContext];
    }
    return self;
}

- (NSManagedObjectContext *)createManagedObjectContext
{
    NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Database.sqlite"];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    return managedObjectContext;
}

+ (instancetype)sharedUserModel
{
    static FWUserModel *sharedUserModel = nil;
    @synchronized(self)
    {
        if (sharedUserModel == nil)
        {
            sharedUserModel = [[self alloc] init];
        }
    }
    return sharedUserModel;
}

- (FWColorSchemeModel *)colorScheme
{
    if (_colorScheme == nil)
    {
        NSArray *colorSchemes = [FWColorSchemeModel colors];
        NSString *colorSchemeGuid = [FWSettingsManager getUserColorSchemeGuid];

        FWColorSchemeModel *userColorScheme = [FWColorSchemeModel colorSchemeFromGuid:colorSchemeGuid inArray:colorSchemes];

        if (userColorScheme == nil) // guid retrieved is either nil or invalid, setting back to default value
        {
            userColorScheme = [colorSchemes firstObject]; // first object is the default
            [FWSettingsManager saveUserColorSchemeGuid:userColorScheme.guid];
        }

        _colorScheme = userColorScheme;
    }

    return _colorScheme;
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    [FWSettingsManager saveUserColorSchemeGuid:colorScheme.guid];
}

- (FWBoardSizeModel *)boardSize
{
    if (_boardSize == nil)
    {
        FWBoardSizeModel *userGameBoardSize = [FWSettingsManager getUserBoardSize];

        NSAssert(userGameBoardSize != nil, @"Game board size object should never be nil.");

        if (userGameBoardSize.numberOfColumns == 0 || userGameBoardSize.numberOfRows == 0)
        {
            userGameBoardSize = [FWBoardSizeModel defaultBoardSize];

            [FWSettingsManager saveUserBoardSize:userGameBoardSize];
        }
        _boardSize = userGameBoardSize;
    }

    return _boardSize;
}

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;
    [FWSettingsManager saveUserBoardSize:boardSize];
}

- (NSArray *)savedGames
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SavedGame" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (result != nil)
    {
        for (FWSavedGame *object in result)
        {
            NSLog(@"%@", object.name);
        }
    }
    return result;
}

- (void)saveGameWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells
{
    NSManagedObjectContext *context = self.managedObjectContext;
    FWSavedGame *savedGame = [NSEntityDescription insertNewObjectForEntityForName:@"SavedGame"
                                                           inManagedObjectContext:context];
    savedGame.name = name;
    savedGame.boardSize = boardSize;
    savedGame.liveCells = liveCells;

    [context save:nil];
}

- (void)editSavedGame:(FWSavedGame *)savedGame
{
    NSManagedObjectContext *context = savedGame.managedObjectContext;
    NSAssert(context != nil, @"The saved game context is nil.");
    [context save:nil];
}

@end