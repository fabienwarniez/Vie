//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameBoardView.h"
#import "FWCell.h"
#import "FWCellView.h"
#import "FWCellIndex.h"
#import "FWBoardSize.h"

@interface FWGameBoardView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect frameUsedToCalculateCellSize;
@property (nonatomic, strong) NSMutableArray *cellViewPool;
@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) NSArray *cellsDiff;
@property (nonatomic, strong) NSMutableDictionary *cellViewsOnBoard;
@property (nonatomic, assign) BOOL initialBoardDrawn;
@property (nonatomic, strong) UIView *cellContainerView;

@end

@implementation FWGameBoardView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _cellContainerView = [[UIView alloc] init];
        _cellContainerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cellContainerView.layer.borderWidth = 1.0f;
        _cellContainerView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_cellContainerView];
        _cellViewPool = [NSMutableArray array];
        _cellViewsOnBoard = [NSMutableDictionary dictionary];
        _initialBoardDrawn = NO;
    }
    return self;
}

- (void)updateCellsWithDiff:(NSArray *)diffArray newCellArray:(NSArray *)wholeCellsArray
{
    if (self.boardSize == nil)
    {
        assert(false); // ensure the game board is always properly initialized
    }
    self.cells = wholeCellsArray;
    self.cellsDiff = diffArray;

    [self setNeedsLayout];
}

// TODO: make sure that calling this method twice in a row does not make it crash
- (void)layoutSubviews
{
    [super layoutSubviews];

    if (![self rect:self.bounds equalsRect:self.frameUsedToCalculateCellSize])
    {
        self.cellSize = [self calculateCellSize];
        self.cellContainerView.frame = CGRectMake(0, 0, self.cellSize.width * self.boardSize.numberOfColumns, self.cellSize.height * self.boardSize.numberOfRows);
        self.cellContainerView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0); // fine on non-retina because both parent and container are odd number of pixels
        self.frameUsedToCalculateCellSize = self.bounds;
        [self updateVisibleCellsForBoundsChange];
    }

    if (self.initialBoardDrawn && self.cellsDiff != nil)
    {
        [self updateGameBoard];

        self.cellsDiff = nil;
    }
    else
    {
        [self drawInitialBoard];

        self.initialBoardDrawn = YES;
    }
}

#pragma mark - Private Methods

- (void)drawInitialBoard
{
    for (NSUInteger columnIndex = 0; columnIndex < self.boardSize.numberOfColumns; columnIndex++)
    {
        for (NSUInteger rowIndex = 0; rowIndex < self.boardSize.numberOfRows; rowIndex++)
        {
            FWCell *cellModel = self.cells[columnIndex * self.boardSize.numberOfRows + rowIndex];
            if (cellModel.alive)
            {
                FWCellView *cellView = [self dequeueCellViewFromPoolWithFrame:[self frameForColumn:columnIndex row:rowIndex]];
                FWCellIndex *changedCellIndex = [[FWCellIndex alloc] initWithColumn:columnIndex row:rowIndex];
                [self.cellViewsOnBoard setObject:cellView forKey:changedCellIndex];
                [self.cellContainerView addSubview:cellView];
            }
        }
    }
}

- (void)updateGameBoard
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
                [self.cellContainerView addSubview:cellView];
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

- (void)updateVisibleCellsForBoundsChange
{
    for (FWCellView *cell in self.cellContainerView.subviews)
    {
        cell.frame = [self frameForColumn:cell.column row:cell.row];
    }
}

- (CGSize)calculateCellSize
{
    CGFloat cellWidth = self.bounds.size.width / self.boardSize.numberOfColumns;
    CGFloat cellHeight = self.bounds.size.height / self.boardSize.numberOfRows;
    CGFloat cellSideLength = floorf(MIN(cellWidth, cellHeight));
    return CGSizeMake(cellSideLength, cellSideLength);
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
        newCell.autoresizingMask = UIViewAutoresizingNone;
        return newCell;
    }
}

- (CGRect)frameForColumn:(NSUInteger)column row:(NSUInteger)row
{
    return CGRectMake(column * self.cellSize.width, row * self.cellSize.height, self.cellSize.width, self.cellSize.height);
}

- (BOOL)rect:(CGRect)rect1 equalsRect:(CGRect)rect2
{
    return rect1.size.width == rect2.size.width
        && rect1.size.height == rect2.size.height
        && rect1.origin.x == rect2.origin.x
        && rect1.origin.y == rect2.origin.y;
}

@end
