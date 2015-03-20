//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class NSManagedObjectContext;
@class FWSavedGameModel;
@class FWBoardSizeModel;

@interface FWSavedGameManager : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (FWSavedGameModel *)createSavedGameWithName:(NSString *)name boardSize:(FWBoardSizeModel *)boardSize liveCells:(NSArray *)liveCells creationDate:(NSDate *)creationDate;
- (NSArray *)savedGamesForSearchString:(NSString *)searchString;

@end
