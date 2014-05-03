//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardView.h"
#import "FWCellModel.h"
#import "FWBoardSizeModel.h"

@interface FWBoardView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect cellContainerFrame;

@end

@implementation FWBoardView

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _minimumBoardPadding = 0.0f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _minimumBoardPadding = 0.0f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat pixelScale = [[UIScreen mainScreen] scale];

    CGFloat totalBorderWidth = (self.boardSize.numberOfColumns - 1) * self.borderWidth;
    CGFloat totalBorderHeight = (self.boardSize.numberOfRows - 1) * self.borderWidth;
    CGFloat maxCellWidth = (self.bounds.size.width - 2 * self.minimumBoardPadding - totalBorderWidth) / self.boardSize.numberOfColumns;
    CGFloat maxCellHeight = (self.bounds.size.height - 2 * self.minimumBoardPadding - totalBorderHeight) / self.boardSize.numberOfRows;
    CGFloat finalCellSideLength = floorf(pixelScale * MIN(maxCellWidth, maxCellHeight)) / pixelScale;

    self.cellSize = CGSizeMake(finalCellSideLength, finalCellSideLength);

    CGFloat finalBoardWidth = self.cellSize.width * self.boardSize.numberOfColumns + totalBorderWidth;
    CGFloat finalBoardHeight = self.cellSize.height * self.boardSize.numberOfRows + totalBorderHeight;
    CGFloat finalHorizontalPadding = (self.bounds.size.width - finalBoardWidth) / 2.0f;
    CGFloat finalVerticalPadding = (self.bounds.size.height - finalBoardHeight) / 2.0f;
    finalHorizontalPadding = floorf(pixelScale * finalHorizontalPadding) / pixelScale;
    finalVerticalPadding = floorf(pixelScale * finalVerticalPadding) / pixelScale;

    self.cellContainerFrame = CGRectMake(finalHorizontalPadding, finalVerticalPadding, finalBoardWidth, finalBoardHeight);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat borderWidth = self.borderWidth;
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);

    CGSize cellSize = self.cellSize;
    CGPoint origin = self.cellContainerFrame.origin;

    for (FWCellModel *cell in self.liveCells)
    {
        if (cell.alive)
        {
            CGRect cellRect = CGRectMake(origin.x + cell.column * (cellSize.width + borderWidth), origin.y + cell.row * (cellSize.height + borderWidth), cellSize.width, cellSize.height);
            CGContextAddRect(context, cellRect);
        }
    }

    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - Accessors

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;

    [self setNeedsLayout];
}

- (void)setLiveCells:(NSArray *)liveCells
{
    NSAssert(self.boardSize != nil, @"The game board size must be set before setting currentCellsNSArray.");

    _liveCells = liveCells;

    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;

    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;

    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (CGSize)calculateCellSize
{
    CGFloat totalBorderWidth = (self.boardSize.numberOfColumns - 1) * self.borderWidth;
    CGFloat totalBorderHeight = (self.boardSize.numberOfRows - 1) * self.borderWidth;
    CGFloat cellWidth = (self.bounds.size.width - 2 * self.minimumBoardPadding - totalBorderWidth) / self.boardSize.numberOfColumns;
    CGFloat cellHeight = (self.bounds.size.height - 2 * self.minimumBoardPadding - totalBorderHeight) / self.boardSize.numberOfRows;
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideLength = floorf(pixelScale * MIN(cellWidth, cellHeight)) / pixelScale;
    return CGSizeMake(cellSideLength, cellSideLength);
}

@end
