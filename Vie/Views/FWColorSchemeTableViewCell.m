//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeTableViewCell.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "FWCellModel.h"
#import "FWRandomNumberGenerator.h"

static NSUInteger kFWColorSchemeTableViewCellNumberOfColumns = 15;
static NSUInteger kFWColorSchemeTableViewCellNumberOfRows = 3;
static CGFloat kFWColorSchemeTableViewCellBorderWidth = 1.0f;

@interface FWColorSchemeTableViewCell ()

@property (nonatomic, strong) FWBoardView *gameBoardView;

@end

@implementation FWColorSchemeTableViewCell

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        _gameBoardView = [[FWBoardView alloc] init];
        _gameBoardView.backgroundColor = [UIColor clearColor];
        _gameBoardView.boardSize = [[FWBoardSizeModel alloc] initWithNumberOfColumns:kFWColorSchemeTableViewCellNumberOfColumns numberOfRows:kFWColorSchemeTableViewCellNumberOfRows];
        _gameBoardView.borderWidth = kFWColorSchemeTableViewCellBorderWidth;
        _gameBoardView.liveCells = [self randomArrayOfCellsWithNumberOfColumns:kFWColorSchemeTableViewCellNumberOfColumns numberOfRows:kFWColorSchemeTableViewCellNumberOfRows];

        [self.contentView addSubview:_gameBoardView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _gameBoardView.frame = CGRectMake(self.contentView.bounds.size.width - 150 - 10, 10, 150, 30);
}

#pragma mark - UITableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.cellPreviewFillColor = nil;
    self.cellPreviewBorderColor = nil;
    self.gameBoardView.liveCells = [self randomArrayOfCellsWithNumberOfColumns:kFWColorSchemeTableViewCellNumberOfColumns numberOfRows:kFWColorSchemeTableViewCellNumberOfRows];
}

#pragma mark - Accessors

- (void)setCellPreviewFillColor:(UIColor *)cellPreviewFillColor
{
    _cellPreviewFillColor = cellPreviewFillColor;
    self.gameBoardView.fillColor = cellPreviewFillColor;
}

- (void)setCellPreviewBorderColor:(UIColor *)cellPreviewBorderColor
{
    _cellPreviewBorderColor = cellPreviewBorderColor;
    self.gameBoardView.borderColor = cellPreviewBorderColor;
}

#pragma mark - Private Methods

- (NSArray *)randomArrayOfCellsWithNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSUInteger columnIterator = 0; columnIterator < numberOfColumns; columnIterator++)
    {
        for (NSUInteger rowIterator = 0; rowIterator < numberOfRows; rowIterator++)
        {
            FWCellModel *cell = [[FWCellModel alloc] init];
            cell.column = columnIterator;
            cell.row = rowIterator;
            cell.alive = [FWRandomNumberGenerator randomBooleanWithPositivePercentageOf:30];
            if (cell.alive)
            {
                [array addObject:cell];
            }
        }
    }

    return [array copy];
}

@end