//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameBoardView.h"
#import "FWCell.h"
#import "FWCellView.h"
#import "FWCellIndex.h"

@interface FWGameBoardView ()

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) NSMutableArray *cellViewPool;
@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSMutableArray *cellsDiff;
@property (nonatomic, strong) NSMutableDictionary *cellViewsOnBoard;
@property (nonatomic, assign) BOOL initialBoardDrawn;

@end

@implementation FWGameBoardView

- (instancetype)initWithNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows cellSize:(CGSize)cellSize
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.numberOfColumns = numberOfColumns;
        self.numberOfRows = numberOfRows;
        _cellSize = cellSize;
        _cellViewPool = [NSMutableArray array];
        _cellViewsOnBoard = [NSMutableDictionary dictionary];
        _initialBoardDrawn = NO;
    }
    return self;
}

- (void)updateCellsWithDiff:(NSMutableArray *)diffArray newCellArray:(NSArray *)wholeCellsArray
{
    self.cells = wholeCellsArray;
    self.cellsDiff = diffArray;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.initialBoardDrawn)
    {
        NSUInteger cellChangeCount = [self.cellsDiff count];
        NSMutableArray *cellViewsToBeRemovedFromView = [NSMutableArray array];

        for (NSUInteger cellIndex = 0; cellIndex < cellChangeCount; cellIndex++)
        {
            FWCell *changedCell = self.cellsDiff[cellIndex];
            FWCellIndex *changedCellIndex = [[FWCellIndex alloc] initWithColumn:changedCell.column row:changedCell.row];
            if (changedCell.alive)
            {
                FWCellView *cellView = [cellViewsToBeRemovedFromView lastObject];
                if (cellView != nil)
                {
                    [cellViewsToBeRemovedFromView removeLastObject];
                    cellView.frame = [self frameForColumn:changedCell.column row:changedCell.row];
                }
                else
                {
                    cellView = [self dequeueCellViewFromPoolWithFrame:[self frameForColumn:changedCell.column row:changedCell.row]];
                    [self addSubview:cellView];
                }
                [self.cellViewsOnBoard setObject:cellView forKey:changedCellIndex];
            }
            else
            {
                FWCellView *cellView = [self.cellViewsOnBoard objectForKey:changedCellIndex];
                [self.cellViewsOnBoard removeObjectForKey:changedCellIndex];
                [cellViewsToBeRemovedFromView addObject:cellView];
            }
        }

        NSUInteger numberOfCellsToBeRemovedFromView = [cellViewsToBeRemovedFromView count];
        for (NSUInteger cellToBeRemovedFromViewIndex = 0; cellToBeRemovedFromViewIndex < numberOfCellsToBeRemovedFromView; cellToBeRemovedFromViewIndex++)
        {
            FWCellView *cellView = cellViewsToBeRemovedFromView[cellToBeRemovedFromViewIndex];
            [self.cellViewPool addObject:cellView];
            [cellView removeFromSuperview];
        }
    }
    else
    {
        for (NSUInteger columnIndex = 0; columnIndex < self.numberOfColumns; columnIndex++)
        {
            for (NSUInteger rowIndex = 0; rowIndex < self.numberOfRows; rowIndex++)
            {
                FWCell *cellModel = self.cells[columnIndex][rowIndex];
                if (cellModel.alive)
                {
                    FWCellView *cellView = [self dequeueCellViewFromPoolWithFrame:[self frameForColumn:columnIndex row:rowIndex]];
                    FWCellIndex *changedCellIndex = [[FWCellIndex alloc] initWithColumn:columnIndex row:rowIndex];
                    [self.cellViewsOnBoard setObject:cellView forKey:changedCellIndex];
                    [self addSubview:cellView];
                }
            }
        }

        self.initialBoardDrawn = YES;
    }
}

- (FWCellView *)dequeueCellViewFromPoolWithFrame:(CGRect)frame
{
    if ([self.cellViewPool count] > 0)
    {
        FWCellView *dequeuedCell = [self.cellViewPool lastObject];
        [self.cellViewPool removeLastObject];
        dequeuedCell.frame = frame;
        return dequeuedCell;
    }
    else
    {
        FWCellView *newCell = [[FWCellView alloc] initWithFrame:frame];
        return newCell;
    }
}

- (CGRect)frameForColumn:(NSUInteger)column row:(NSUInteger)row
{
    return CGRectMake(column * self.cellSize.width, row * self.cellSize.height, self.cellSize.width, self.cellSize.height);
}

@end
