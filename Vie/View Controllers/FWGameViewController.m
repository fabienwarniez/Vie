//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"
#import "FWCell.h"
#import "FWGameBoardView.h"

NSUInteger const CELL_WIDTH = 5;
NSUInteger const CELL_HEIGHT = 5;

@interface FWGameViewController ()

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSArray *secondArrayOfCells;
@property (nonatomic, strong) NSArray *initialBoard;
@property (nonatomic, strong) FWGameBoardView *gameBoardView;
@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation FWGameViewController

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _numberOfColumns = (NSUInteger) (size.width / CELL_WIDTH);
        _numberOfRows = (NSUInteger) (size.height / CELL_HEIGHT);

        _cells = [self generateInitialCellsWithColumns:_numberOfColumns rows:_numberOfRows];
        _secondArrayOfCells = [self generateInitialCellsWithColumns:_numberOfColumns rows:_numberOfRows];

//        _cells = [self generateCellsFromArray:
//                @[
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @1, @1, @1, @0],
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0]
//                ]];
//
//        _secondArrayOfCells = [self generateCellsFromArray:
//                @[
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0],
//                        @[@0, @0, @0, @0, @0]
//                ]];

        _gameBoardView = [[FWGameBoardView alloc] initWithNumberOfColumns:_numberOfColumns numberOfRows:_numberOfRows cellSize:CGSizeMake(CELL_WIDTH, CELL_HEIGHT)];
        [_gameBoardView updateCellsWithDiff:nil newCellArray:_cells];

        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(calculateNextCycle:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    return self;
}

- (NSArray *)generateCellsFromArray:(NSArray *)simpleArray
{
    NSMutableArray *columns = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < [simpleArray count]; columnIndex++)
    {
        NSArray *simpleRow = simpleArray[columnIndex];
        NSMutableArray *columnOfCells = [NSMutableArray array];
        for (NSUInteger rowIndex = 0; rowIndex < [simpleRow count]; rowIndex++)
        {
            FWCell *newCell = [[FWCell alloc] init];

            newCell.alive = [simpleRow[rowIndex] unsignedIntegerValue] == 1;

            columnOfCells[rowIndex] = newCell;
        }
        columns[columnIndex] = columnOfCells;
    }

    return columns;
}

- (NSArray *)generateInitialCellsWithColumns:(NSUInteger)numberOfColumns rows:(NSUInteger)numberOfRows
{
    NSMutableArray *columns = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++)
    {
        NSMutableArray *columnOfCells = [NSMutableArray array];
        for (NSUInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
        {
            FWCell *newCell = [[FWCell alloc] init];

            newCell.column = columnIndex;
            newCell.row = rowIndex;

            float low_bound = 0;
            float high_bound = 100;
            float rndValue = (((float)arc4random() / 0x100000000) * (high_bound - low_bound) + low_bound);
            newCell.alive = rndValue > 80;

            columnOfCells[rowIndex] = newCell;
        }
        columns[columnIndex] = columnOfCells;
    }

    return columns;
}

- (void)calculateNextCycle:(NSTimer *)senderTimer
{
    NSArray *nextCycleArray = self.secondArrayOfCells;
    self.secondArrayOfCells = self.cells;
    NSMutableArray *arrayOfChanges = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < _numberOfColumns; columnIndex++)
    {
        for (NSUInteger rowIndex = 0; rowIndex < _numberOfRows; rowIndex++)
        {
            FWCell *currentCell = [self cellInColumn:columnIndex inRow:rowIndex inArray:self.cells];
            FWCell *nextCycleCell = [self cellInColumn:columnIndex inRow:rowIndex inArray:nextCycleArray];
            NSUInteger numberOfNeighbours = 0;
            for (NSInteger columnOffsetIndex = -1; columnOffsetIndex <= 1; columnOffsetIndex++)
            {
                for (NSInteger rowOffsetIndex = -1; rowOffsetIndex <= 1; rowOffsetIndex++)
                {
                    NSInteger neighbourColumnIndex = columnOffsetIndex + columnIndex;
                    NSInteger neighbourRowIndex = rowOffsetIndex + rowIndex;

                    if ((columnOffsetIndex != 0 || rowOffsetIndex != 0) && neighbourColumnIndex >= 0 && neighbourRowIndex >= 0)
                    {
                        FWCell *neighbourCell = [self cellInColumn:(NSUInteger) neighbourColumnIndex inRow:(NSUInteger) neighbourRowIndex inArray:self.cells];
                        if (neighbourCell != nil && neighbourCell.alive)
                        {
                            numberOfNeighbours++;
                        }
                    }
                }
            }

            if (currentCell.alive)
            {
                if (numberOfNeighbours < 2 || numberOfNeighbours > 3)
                {
                    nextCycleCell.alive = NO;
                    [arrayOfChanges addObject:nextCycleCell];
                }
                else
                {
                    nextCycleCell.alive = YES;
                }
            }
            else
            {
                if (numberOfNeighbours == 3)
                {
                    nextCycleCell.alive = YES;
                    [arrayOfChanges addObject:nextCycleCell];
                }
                else
                {
                    nextCycleCell.alive = NO;
                }
            }
        }
    }

    self.cells = nextCycleArray;
    [self.gameBoardView updateCellsWithDiff:arrayOfChanges newCellArray:self.cells];
}

- (FWCell *)cellInColumn:(NSUInteger)column inRow:(NSUInteger)row inArray:(NSArray *)columns
{
    if (column >= self.numberOfColumns || row >= self.numberOfRows)
    {
        return nil;
    }
    else
    {
        NSArray *rowOfCells = columns[column];
        assert([rowOfCells count] > row);
        return rowOfCells[row];
    }
}

- (void)loadView
{
    self.gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = self.gameBoardView;
}

@end