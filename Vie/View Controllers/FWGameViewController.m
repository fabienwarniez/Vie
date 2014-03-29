//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"
#import "FWCell.h"
#import "FWGameBoardView.h"

NSUInteger const CELL_WIDTH = 10;
NSUInteger const CELL_HEIGHT = 10;

@interface FWGameViewController ()

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSArray *cells;
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

        _gameBoardView = [[FWGameBoardView alloc] initWithNumberOfColumns:_numberOfColumns numberOfRows:_numberOfRows cellSize:CGSizeMake(CELL_WIDTH, CELL_HEIGHT)];
        [_gameBoardView setCells:_cells];

        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(calculateNextCycle:)
                                                       userInfo:nil
                                                        repeats:NO];
    }
    return self;
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

            float low_bound = 0;
            float high_bound = 100;
            float rndValue = (((float)arc4random() / 0x100000000) * (high_bound - low_bound) + low_bound);
            newCell.alive = rndValue > 90;

            columnOfCells[rowIndex] = newCell;
        }
        columns[columnIndex] = columnOfCells;
    }

    return columns;
}

- (void)calculateNextCycle:(NSTimer *)senderTimer
{
    NSMutableArray *newColumns = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < _numberOfColumns; columnIndex++)
    {
        NSMutableArray *columnOfCells = [NSMutableArray array];

        for (NSUInteger rowIndex = 0; rowIndex < _numberOfRows; rowIndex++)
        {
            FWCell *currentCell = [self cellInColumn:columnIndex inRow:rowIndex];
            NSUInteger numberOfNeighbours = 0;
            for (NSInteger columnOffsetIndex = -1; columnOffsetIndex <= 1; columnOffsetIndex++)
            {
                for (NSInteger rowOffsetIndex = -1; rowOffsetIndex <= 1; rowOffsetIndex++)
                {
                    NSInteger neighbourColumnIndex = columnOffsetIndex + columnIndex;
                    NSInteger neighbourRowIndex = rowOffsetIndex + rowIndex;

                    if (columnOffsetIndex != 0 && rowOffsetIndex != 0 && neighbourColumnIndex >= 0 && neighbourRowIndex >= 0)
                    {
                        FWCell *neighbourCell = [self cellInColumn:(NSUInteger) neighbourColumnIndex inRow:(NSUInteger) neighbourRowIndex];
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
                    currentCell.alive = NO;
                }
            }
            else
            {
                if (numberOfNeighbours >= 3)
                {
                    currentCell.alive = YES;
                }
            }

            columnOfCells[rowIndex] = newCell;
        }

        newColumns[columnIndex] = columnOfCells;
    }

    [self.gameBoardView setCells:self.cells];
}

- (FWCell *)cellInColumn:(NSUInteger)column inRow:(NSUInteger)row
{
    if (column < 0 || column >= self.numberOfColumns || row < 0 || row >= self.numberOfRows)
    {
        return nil;
    }
    else
    {
        NSArray *rowOfCells = _cells[column];
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