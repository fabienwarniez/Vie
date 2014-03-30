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
    NSMutableArray *cells = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < [simpleArray count]; columnIndex++)
    {
        NSArray *simpleRow = simpleArray[columnIndex];
        for (NSUInteger rowIndex = 0; rowIndex < [simpleRow count]; rowIndex++)
        {
            FWCell *newCell = [[FWCell alloc] init];

            newCell.alive = [simpleRow[rowIndex] unsignedIntegerValue] == 1;

            cells[columnIndex * self.numberOfRows + rowIndex] = newCell;
        }
    }

    return cells;
}

- (NSArray *)generateInitialCellsWithColumns:(NSUInteger)numberOfColumns rows:(NSUInteger)numberOfRows
{
    NSMutableArray *cells = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++)
    {
        for (NSUInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
        {
            FWCell *newCell = [[FWCell alloc] init];

            newCell.column = columnIndex;
            newCell.row = rowIndex;

            float low_bound = 0;
            float high_bound = 100;
            float rndValue = (((float)arc4random() / 0x100000000) * (high_bound - low_bound) + low_bound);
            newCell.alive = rndValue > 80;

            cells[columnIndex * numberOfRows + rowIndex] = newCell;
        }
    }

    return cells;
}

- (void)calculateNextCycle:(NSTimer *)senderTimer
{
    NSArray *nextCycleArray = self.secondArrayOfCells;
    NSArray *currentCycleArray = self.cells;
    NSMutableArray *arrayOfChanges = [NSMutableArray array];
    NSUInteger numberOfColumns = self.numberOfColumns; // performance optimization
    NSUInteger numberOfRows = self.numberOfRows;

    for (NSUInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++)
    {
        for (NSUInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
        {
            FWCell *currentCell = [self cellForColumn:columnIndex row:rowIndex inArray:currentCycleArray];
            FWCell *nextCycleCell = [self cellForColumn:columnIndex row:rowIndex inArray:nextCycleArray];
            NSUInteger numberOfNeighbours = 0;
            for (NSInteger columnOffsetIndex = -1; columnOffsetIndex <= 1; columnOffsetIndex++)
            {
                for (NSInteger rowOffsetIndex = -1; rowOffsetIndex <= 1; rowOffsetIndex++)
                {
                    NSInteger neighbourColumnIndex = columnOffsetIndex + columnIndex;
                    NSInteger neighbourRowIndex = rowOffsetIndex + rowIndex;

                    if ((columnOffsetIndex != 0 || rowOffsetIndex != 0)
                        && neighbourColumnIndex >= 0 && neighbourRowIndex >= 0
                        && neighbourColumnIndex < numberOfColumns && neighbourRowIndex < numberOfRows)
                    {
                        FWCell *neighbourCell = [self cellForColumn:(NSUInteger) neighbourColumnIndex row:(NSUInteger) neighbourRowIndex inArray:currentCycleArray];
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
                    [arrayOfChanges insertObject:nextCycleCell atIndex:0];
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
    self.secondArrayOfCells = currentCycleArray;
    [self.gameBoardView updateCellsWithDiff:arrayOfChanges newCellArray:nextCycleArray];
}

- (FWCell *)cellForColumn:(NSUInteger)column row:(NSUInteger)row inArray:(NSArray *)array
{
    return array[column * _numberOfRows + row];
}

- (void)loadView
{
    self.gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = self.gameBoardView;
}

@end