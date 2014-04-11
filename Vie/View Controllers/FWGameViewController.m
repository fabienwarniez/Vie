//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"
#import "FWCell.h"
#import "FWGameBoardView.h"
#import "FWBoardSize.h"

@interface FWGameViewController ()

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSArray *secondArrayOfCells;
@property (nonatomic, strong) NSArray *initialBoard;
@property (nonatomic, strong) NSTimer *refreshTimer;

@end

@implementation FWGameViewController

- (void)setBoardSize:(FWBoardSize *)boardSize
{
    _boardSize = boardSize;
    self.gameBoardView.boardSize = boardSize;
}

- (void)viewDidLoad
{
    self.cells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];
    self.secondArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];

    self.gameBoardView.boardSize = self.boardSize;
    [self.gameBoardView updateCellsWithDiff:nil newCellArray:self.cells];

    [self play];
}

- (BOOL)isRunning
{
    return self.refreshTimer != nil && [self.refreshTimer isValid];
}

- (void)play
{
    if (self.refreshTimer == nil || ![self.refreshTimer isValid])
    {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(calculateNextCycle:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
}

- (void)pause
{
    if ([self.refreshTimer isValid])
    {
        [self.refreshTimer invalidate];
    }
}

- (IBAction)playPauseButtonTapped:(id)sender
{
    if ([self isRunning])
    {
        [self pause];
        self.playPauseButtonItem.title = @"Play";
    }
    else
    {
        [self play];
        self.playPauseButtonItem.title = @"Pause";
    }
}

- (IBAction)nextButtonTapped:(id)sender
{
    if (![self isRunning])
    {
        [self calculateNextCycle:nil];
    }
}

/*
  Debugging purposes
 */
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

            cells[columnIndex * self.boardSize.numberOfRows + rowIndex] = newCell;
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
    NSUInteger numberOfColumns = self.boardSize.numberOfColumns; // performance optimization
    NSUInteger numberOfRows = self.boardSize.numberOfRows;

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
    return array[column * _boardSize.numberOfRows + row];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self pause];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self play];
}

@end