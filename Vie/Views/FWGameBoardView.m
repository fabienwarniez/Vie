//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameBoardView.h"
#import "FWCell.h"
#import "FWCellView.h"

@interface FWGameBoardView ()

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) NSMutableArray *cellsPool;

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
        _cellsPool = [NSMutableArray array];
    }
    return self;
}

- (void)setCells:(NSArray *)cells
{
    _cells = cells;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (NSUInteger i = 0; i < self.numberOfColumns; i++)
    {
        for (NSUInteger j = 0; j < self.numberOfRows; j++)
        {
            FWCell *cellModel = self.cells[i][j];
            if (cellModel.alive)
            {
                FWCellView *cellView = [[FWCellView alloc] initWithFrame:CGRectMake(i * self.cellSize.width, j * self.cellSize.height, self.cellSize.width, self.cellSize.height)];
                cellView.data = cellModel;
                [self addSubview:cellView];
            }
        }
    }
}

@end