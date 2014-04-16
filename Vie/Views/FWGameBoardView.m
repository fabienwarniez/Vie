//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameBoardView.h"
#import "FWCell.h"
#import "FWBoardSize.h"

static CGFloat kFWBoardPadding = 5.0f;

@interface FWGameBoardView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect frameUsedToCalculateCellSize;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, assign) CGRect cellContainerFrame;

@end

@implementation FWGameBoardView

- (void)updateLiveCellList:(NSArray *)liveCells
{
    if (self.boardSize == nil)
    {
        assert(false); // ensure the game board is always properly initialized
    }
    self.liveCells = liveCells;
//    self.cellsDiff = diffArray;
    
//    if (self.cellsDiff == nil)
//    {
//        self.needsWipeout = YES;
//    }

    [self setNeedsDisplay];
}

// TODO: make sure that calling this method twice in a row does not make it crash
- (void)layoutSubviews
{
    [super layoutSubviews];

    if (![self rect:self.bounds equalsRect:self.frameUsedToCalculateCellSize])
    {
        self.cellSize = [self calculateCellSize];
        CGFloat finalPadding = (self.bounds.size.width - self.cellSize.width * self.boardSize.numberOfColumns) / 2.0f;
        self.cellContainerFrame =
            CGRectMake(finalPadding, finalPadding, self.cellSize.width * self.boardSize.numberOfColumns, self.cellSize.height * self.boardSize.numberOfRows);
        self.frameUsedToCalculateCellSize = self.bounds;
    }

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);

    CGSize cellSize = self.cellSize;
    CGPoint origin = self.cellContainerFrame.origin;

    for (FWCell *cell in self.liveCells)
    {
        if (cell.alive)
        {
            CGContextAddRect(context, CGRectMake(origin.x + cell.column * cellSize.width, origin.y + cell.row * cellSize.height, cellSize.width, cellSize.height));
        }
    }

    CGContextStrokePath(context);
}

#pragma mark - Private Methods

- (CGSize)calculateCellSize
{
    CGFloat cellWidth = (self.bounds.size.width - 2 * kFWBoardPadding) / self.boardSize.numberOfColumns;
    CGFloat cellHeight = self.bounds.size.height / self.boardSize.numberOfRows;
    CGFloat cellSideLength = floorf(MIN(cellWidth, cellHeight));
    return CGSizeMake(cellSideLength, cellSideLength);
}

- (BOOL)rect:(CGRect)rect1 equalsRect:(CGRect)rect2
{
    return rect1.size.width == rect2.size.width
        && rect1.size.height == rect2.size.height
        && rect1.origin.x == rect2.origin.x
        && rect1.origin.y == rect2.origin.y;
}

@end
