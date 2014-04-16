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
@property (nonatomic, assign) BOOL wasPlayingBeforeInterruption;

@end

@implementation FWGameViewController

#pragma mark - Accessors

- (void)setBoardSize:(FWBoardSize *)boardSize
{
    _boardSize = boardSize;
    self.gameBoardView.boardSize = boardSize;
}

- (BOOL)isRunning
{
    return self.refreshTimer != nil && [self.refreshTimer isValid];
}

#pragma mark - UIViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self interruptGame];
    [self.gameBoardView setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resumeAfterInterruption];
}

- (void)viewDidLoad
{
    self.cells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];
    self.secondArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];

    NSArray *liveCells = [self liveCellsFromGameMatrix:self.cells];

    self.gameBoardView.boardSize = self.boardSize;
    [self.gameBoardView updateLiveCellList:liveCells];

    [self pause];
}

#pragma mark - Game Lifecycle Management

- (void)interruptGame
{
    self.wasPlayingBeforeInterruption = [self isRunning];
    [self pause];
}

- (void)resumeAfterInterruption
{
    if (self.wasPlayingBeforeInterruption)
    {
        [self play];
    }
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
    self.pauseButtonItem.enabled = YES;
    self.playButtonItem.enabled = NO;
}

- (void)pause
{
    if ([self.refreshTimer isValid])
    {
        [self.refreshTimer invalidate];
    }
    self.pauseButtonItem.enabled = NO;
    self.playButtonItem.enabled = YES;
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
    [self calculateNextCycle];
}

- (void)calculateNextCycle
{
    NSArray *nextCycleArray = self.secondArrayOfCells;
    NSArray *currentCycleArray = self.cells;
    NSMutableArray *liveCellsArray = [NSMutableArray array];
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
                }
                else
                {
                    nextCycleCell.alive = NO;
                }
            }

            if (nextCycleCell.alive)
            {
                [liveCellsArray addObject:nextCycleCell];
            }
        }
    }

    self.cells = nextCycleArray;
    self.secondArrayOfCells = currentCycleArray;
    [self.gameBoardView updateLiveCellList:liveCellsArray];
}

#pragma mark - IBActions

- (IBAction)reloadButtonTapped:(id)sender
{
    if ([self isRunning])
    {
        [self pause];
    }

    self.cells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];
    self.secondArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows];

    NSArray *liveCells = [self liveCellsFromGameMatrix:self.cells];

    [self.gameBoardView updateLiveCellList:liveCells];
}

- (IBAction)pauseButtonTapped:(id)sender
{
    if ([self isRunning])
    {
        [self pause];
    }
}

- (IBAction)playButtonTapped:(id)sender
{
    if (![self isRunning])
    {
        [self play];
    }
}

- (IBAction)backButtonTapped:(id)sender
{
    // later
}

- (IBAction)nextButtonTapped:(id)sender
{
    if ([self isRunning])
    {
        [self pause];
    }
    else
    {
        [self calculateNextCycle];
    }
}

#pragma mark - Private Methods

- (NSArray *)liveCellsFromGameMatrix:(NSArray *)cells
{
    NSMutableArray *liveCellsArray = [NSMutableArray array];

    for (FWCell *cell in cells)
    {
        if (cell.alive)
        {
            [liveCellsArray addObject:cell];
        }
    }

    return [liveCellsArray copy];
}

- (FWCell *)cellForColumn:(NSUInteger)column row:(NSUInteger)row inArray:(NSArray *)array
{
    return array[column * _boardSize.numberOfRows + row];
}

@end