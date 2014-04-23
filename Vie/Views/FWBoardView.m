//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardView.h"
#import "FWCellModel.h"
#import "FWBoardSizeModel.h"

@interface FWBoardView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect frameUsedToCalculateCellSize;
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

    if (![self rect:self.bounds equalsRect:self.frameUsedToCalculateCellSize])
    {
        self.cellSize = [self calculateCellSize];

        CGFloat numberOfColumns = self.boardSize.numberOfColumns;
        CGFloat finalPadding = (self.bounds.size.width - self.cellSize.width * numberOfColumns) / 2.0f;

        self.cellContainerFrame =
                CGRectMake(finalPadding, self.boardPadding, self.cellSize.width * self.boardSize.numberOfColumns, self.cellSize.height * self.boardSize.numberOfRows);
        self.frameUsedToCalculateCellSize = self.bounds;
    }
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

- (void)setLiveCells:(NSArray *)liveCells
{
    NSAssert(self.boardSize != nil, @"The game board size must be set before setting cellsNSArray.");

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
