//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"
#import "FWCell.h"
#import "FWGameBoardView.h"

NSUInteger const CELL_WIDTH = 10;
NSUInteger const CELL_HEIGHT = 10;

@interface FWGameViewController ()

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, strong) FWGameBoardView *gameBoardView;

@end

@implementation FWGameViewController

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _numberOfColumns = (NSUInteger) (size.width / CELL_WIDTH);
        _numberOfRows = (NSUInteger) (size.height / CELL_HEIGHT);
        _columns = [NSMutableArray array];

        for (NSUInteger i = 0; i < _numberOfColumns; i++)
        {
            NSMutableArray *columnOfCells = [NSMutableArray array];
            for (NSUInteger j = 0; j < _numberOfRows; j++)
            {
                FWCell *newCell = [[FWCell alloc] init];

                float low_bound = 0;
                float high_bound = 100;
                float rndValue = (((float)arc4random() / 0x100000000) * (high_bound - low_bound) + low_bound);
                newCell.alive = rndValue > 90;

                columnOfCells[j] = newCell;
            }
            _columns[i] = columnOfCells;
        }

        _gameBoardView = [[FWGameBoardView alloc] initWithNumberOfColumns:_numberOfColumns numberOfRows:_numberOfRows cellSize:CGSizeMake(CELL_WIDTH, CELL_HEIGHT)];
        [_gameBoardView setCells:_columns];
    }
    return self;
}

- (void)loadView
{
    self.gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = self.gameBoardView;
}

@end