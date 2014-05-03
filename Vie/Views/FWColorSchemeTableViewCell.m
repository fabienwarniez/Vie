//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorSchemeTableViewCell.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "FWCellModel.h"
#import "FWRandomNumberGenerator.h"

static CGFloat const kFWColorSchemeTableViewCellBorderWidth = 2.0f;
static CGFloat const kFWColorSchemeTableViewCellSpacingWidth = 15.0f;
static CGFloat const kFWColorSchemeTableViewCellBoardWidthForPhone = 180.0f;
static CGFloat const kFWColorSchemeTableViewCellBoardWidthForPad = 260.0f;
static CGFloat const kFWColorSchemeTableViewCellBoardHeight = 30.0f;
static CGFloat const kFWColorSchemeTableViewCellCellSize = 10.0f;
static NSUInteger const kFWColorSchemeTableViewCellLiveCellPercentage = 30;

@interface FWColorSchemeTableViewCell ()

@property (nonatomic, strong) FWBoardView *gameBoardView;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;

@end

@implementation FWColorSchemeTableViewCell

#pragma mark - UIView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _numberOfColumns = (NSUInteger) (kFWColorSchemeTableViewCellBoardWidthForPhone / kFWColorSchemeTableViewCellCellSize);
        }
        else
        {
            _numberOfColumns = (NSUInteger) (kFWColorSchemeTableViewCellBoardWidthForPad / kFWColorSchemeTableViewCellCellSize);
        }
        _numberOfRows = (NSUInteger) (kFWColorSchemeTableViewCellBoardHeight / kFWColorSchemeTableViewCellCellSize);

        _gameBoardView = [[FWBoardView alloc] init];
        _gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _gameBoardView.backgroundColor = [UIColor clearColor];
        _gameBoardView.boardSize = [[FWBoardSizeModel alloc] initWithName:nil numberOfColumns:_numberOfColumns numberOfRows:_numberOfRows];
        _gameBoardView.borderWidth = kFWColorSchemeTableViewCellBorderWidth;
        _gameBoardView.liveCells = [self randomArrayOfCellsWithNumberOfColumns:_numberOfColumns numberOfRows:_numberOfRows];

        [self.contentView addSubview:_gameBoardView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat yOffset = (self.contentView.bounds.size.height - kFWColorSchemeTableViewCellBoardHeight) / 2.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        _gameBoardView.frame = CGRectMake(kFWColorSchemeTableViewCellSpacingWidth, yOffset, kFWColorSchemeTableViewCellBoardWidthForPhone, kFWColorSchemeTableViewCellBoardHeight);
    }
    else
    {
        _gameBoardView.frame = CGRectMake(kFWColorSchemeTableViewCellSpacingWidth, yOffset, kFWColorSchemeTableViewCellBoardWidthForPad, kFWColorSchemeTableViewCellBoardHeight);
    }
}

#pragma mark - UITableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.cellPreviewFillColor = nil;
    self.gameBoardView.liveCells = [self randomArrayOfCellsWithNumberOfColumns:_numberOfColumns numberOfRows:_numberOfRows];
}

#pragma mark - Accessors

- (void)setCellPreviewFillColor:(UIColor *)cellPreviewFillColor
{
    _cellPreviewFillColor = cellPreviewFillColor;
    self.gameBoardView.fillColor = cellPreviewFillColor;
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
            cell.alive = [FWRandomNumberGenerator randomBooleanWithPositivePercentageOf:kFWColorSchemeTableViewCellLiveCellPercentage];
            if (cell.alive)
            {
                [array addObject:cell];
            }
        }
    }

    return [array copy];
}

@end