//
//  Created by Fabien Warniez on 2014-08-30.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSavedGameModel.h"
#import "FWCellModel.h"
#import "FWBoardSizeModel.h"

@interface FWSavedGameModel ()

@property (nonatomic, strong) NSString *serializedLiveCells;
@property (nonatomic, strong) NSNumber *boardWidth;
@property (nonatomic, strong) NSNumber *boardHeight;

@end

@implementation FWSavedGameModel

@dynamic name;
@dynamic serializedLiveCells;
@dynamic boardWidth;
@dynamic boardHeight;

@synthesize liveCells=_liveCells;
@synthesize boardSize=_boardSize;

#pragma mark - Accessors

- (void)setLiveCells:(NSArray *)liveCells
{
    _liveCells = liveCells;
    self.serializedLiveCells = [self serializeLiveCells];
}

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;
    self.boardWidth = @(boardSize.numberOfColumns);
    self.boardHeight = @(boardSize.numberOfRows);
}

#pragma mark - NSManagedObject

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    self.boardSize = [FWBoardSizeModel boardSizeWithName:nil numberOfColumns:[self.boardWidth unsignedIntegerValue] numberOfRows:[self.boardHeight unsignedIntegerValue]];
    self.liveCells = [self deserializeLiveCells];
}

#pragma mark - Private Methods

- (NSArray *)deserializeLiveCells
{
    NSArray *components = [self.serializedLiveCells componentsSeparatedByString:@","];
    NSMutableArray *deserializedCells = [NSMutableArray array];
    for (NSNumber *liveCellIndexObject in components)
    {
        NSUInteger liveCellIndex = (NSUInteger) [liveCellIndexObject integerValue];
        NSUInteger column = liveCellIndex / [self.boardHeight unsignedIntegerValue];
        NSUInteger row = liveCellIndex % [self.boardHeight unsignedIntegerValue];
        FWCellModel *cellModel = [FWCellModel cellWithAlive:YES column:column row:row];
        [deserializedCells addObject:cellModel];
    }
    return deserializedCells;
}

- (NSString *)serializeLiveCells
{
    NSMutableArray *stringifiedCells = [NSMutableArray array];
    for (FWCellModel *cell in self.liveCells)
    {
        NSNumber *cellIndex = @(cell.column * self.boardSize.numberOfRows + cell.row);
        [stringifiedCells addObject:cellIndex];
    }
    return [stringifiedCells componentsJoinedByString:@","];
}

@end
