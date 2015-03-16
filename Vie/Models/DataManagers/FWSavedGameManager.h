//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class NSManagedObjectContext;
@class FWSavedGameModel;

@interface FWSavedGameManager : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (FWSavedGameModel *)createSavedGameModel;

- (NSArray *)savedGamesForSearchString:(NSString *)searchString;
- (NSUInteger)savedGameCount;

@end
