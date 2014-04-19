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
    NSAssert(self.boardSize != nil, @"The game board size must be set before setting cells.");

    self.liveCells = liveCells;

    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (![self rect:self.bounds equalsRect:self.frameUsedToCalculateCellSize])
    {
        self.cellSize = [self calculateCellSize];

        CGFloat numberOfColumns = self.boardSize.numberOfColumns;
        CGFloat finalPadding = (self.bounds.size.width - self.cellSize.width * numberOfColumns) / 2.0f;

        self.cellContainerFrame =
            CGRectMake(finalPadding, kFWBoardPadding, self.cellSize.width * self.boardSize.numberOfColumns, self.cellSize.height * self.boardSize.numberOfRows);
        self.frameUsedToCalculateCellSize = self.bounds;
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);

    CGSize cellSize = self.cellSize;
    CGPoint origin = self.cellContainerFrame.origin;

    for (FWCell *cell in self.liveCells)
    {
        if (cell.alive)
        {
            CGContextAddRect(context, CGRectMake(origin.x + cell.column * cellSize.width, origin.y + cell.row * cellSize.height, cellSize.width, cellSize.height));
        }
    }

    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - Private Methods

- (CGSize)calculateCellSize
{
    CGFloat cellWidth = (self.bounds.size.width - 2 * kFWBoardPadding) / self.boardSize.numberOfColumns;
    CGFloat cellHeight = (self.bounds.size.height - 2 * kFWBoardPadding) / self.boardSize.numberOfRows;
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
