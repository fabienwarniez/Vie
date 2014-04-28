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
        _boardPadding = 0.0f;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _boardPadding = 0.0f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.cellSize = [self calculateCellSize];

    // Apparently need to cast the NSUInteger into CGFloat to use in calculations
    CGFloat numberOfColumns = self.boardSize.numberOfColumns;
    CGFloat finalHorizontalPadding = (self.bounds.size.width - self.cellSize.width * numberOfColumns) / 2.0f;
    CGFloat numberOfRows = self.boardSize.numberOfRows;
    CGFloat verticalPadding = (self.bounds.size.height - self.cellSize.height * numberOfRows) / 2.0f;

    self.cellContainerFrame =
            CGRectMake(finalHorizontalPadding, verticalPadding, self.cellSize.width * self.boardSize.numberOfColumns, self.cellSize.height * self.boardSize.numberOfRows);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat borderWidth = self.borderWidth;
    CGFloat borderInset = borderWidth / 2.0f;
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);

    CGSize cellSize = self.cellSize;
    CGPoint origin = self.cellContainerFrame.origin;

    for (FWCellModel *cell in self.liveCells)
    {
        if (cell.alive)
        {
            CGRect cellRect = CGRectMake(origin.x + cell.column * cellSize.width, origin.y + cell.row * cellSize.height, cellSize.width, cellSize.height);
            CGContextAddRect(context, CGRectInset(cellRect, borderInset, borderInset));
        }
    }

    CGContextDrawPath(context, kCGPathFillStroke);
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

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;

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
    CGFloat cellWidth = (self.bounds.size.width - 2 * self.boardPadding) / self.boardSize.numberOfColumns;
    CGFloat cellHeight = (self.bounds.size.height - 2 * self.boardPadding) / self.boardSize.numberOfRows;
    CGFloat pixelScale = [[UIScreen mainScreen] scale];
    CGFloat cellSideLength = floorf(pixelScale * MIN(cellWidth, cellHeight)) / pixelScale;
    return CGSizeMake(cellSideLength, cellSideLength);
}

@end
