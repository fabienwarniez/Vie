//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWBoardView.h"
#import "FWCellModel.h"
#import "FWBoardSizeModel.h"
#import "FWColorSchemeModel.h"
#import "FWGameViewController.h"

static NSUInteger const kFWNumberOfCellAgeGroups = 3;

@interface FWBoardView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect cellContainerFrame;

@end

@implementation FWBoardView

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder
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

#pragma mark - UIView

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

    CGSize cellSize = self.cellSize;
    CGPoint origin = self.cellContainerFrame.origin;

    for (NSUInteger i = 0; i < kFWNumberOfCellAgeGroups; i++)
    {
        NSArray *groupedCells = self.liveCells[i];
        for (FWCellModel *cell in groupedCells)
        {
            CGRect cellRect = CGRectMake(origin.x + cell.column * (cellSize.width + borderWidth), origin.y + cell.row * (cellSize.height + borderWidth), cellSize.width, cellSize.height);
            CGContextAddRect(context, cellRect);
        }

        if (i == FWCellAgeGroupYoung)
        {
            CGContextSetFillColorWithColor(context, self.fillColorScheme.youngFillColor.CGColor);
        }
        else if (i == FWCellAgeGroupMedium)
        {
            CGContextSetFillColorWithColor(context, self.fillColorScheme.mediumFillColor.CGColor);
        }
        else if (i == FWCellAgeGroupOld)
        {
            CGContextSetFillColorWithColor(context, self.fillColorScheme.oldFillColor.CGColor);
        }

        CGContextDrawPath(context, kCGPathFill);
    }
}

#pragma mark - Accessors

- (void)setLiveCells:(NSArray *)liveCells
{
    if (liveCells != nil)
    {
        NSAssert(self.boardSize != nil, @"The game board size must be set before setting currentCellsNSArray.");
        NSAssert(liveCells.count == 3, @"Trying to set an array of cells with more or less than 3 age groups.");
    }

    _liveCells = liveCells;

    [self setNeedsDisplay];
}

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    _boardSize = boardSize;

    [self setNeedsLayout];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;

    [self setNeedsDisplay];
}

- (void)setFillColorScheme:(FWColorSchemeModel *)fillColorScheme
{
    _fillColorScheme = fillColorScheme;

    [self setNeedsDisplay];
}

@end
