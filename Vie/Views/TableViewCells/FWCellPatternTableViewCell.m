//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternTableViewCell.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "FWCellModel.h"
#import "FWCellPatternModel.h"
#import "FWCellPatternModel.h"
#import "FWColorSchemeModel.h"

static CGFloat const kFWCellPatternTableViewCellBorderWidth = 1.0f;
static CGFloat const kFWCellPatternTableViewCellSpacingWidth = 15.0f;
static CGFloat const kFWCellPatternTableViewCellLabelWidth = 50.0f;
static CGFloat const kFWCellPatternTableViewCellVerticalPadding = 10.0f;

@interface FWCellPatternTableViewCell ()

@property (nonatomic, strong) FWBoardView *gameBoardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FWBoardSizeModel * boardSize;

@end

@implementation FWCellPatternTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];

        _gameBoardView = [[FWBoardView alloc] init];
        _gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _gameBoardView.backgroundColor = [UIColor clearColor];
        _gameBoardView.borderWidth = kFWCellPatternTableViewCellBorderWidth;
        [self.contentView addSubview:_gameBoardView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(kFWCellPatternTableViewCellLabelWidth, self.contentView.bounds.size.height)];
    self.titleLabel.frame = CGRectMake(
            kFWCellPatternTableViewCellSpacingWidth,
            (self.contentView.bounds.size.height - labelSize.height) / 2.0f,
            kFWCellPatternTableViewCellLabelWidth,
            labelSize.height);
    self.gameBoardView.frame = CGRectMake(
            CGRectGetMaxX(self.titleLabel.frame) + kFWCellPatternTableViewCellSpacingWidth,
            kFWCellPatternTableViewCellVerticalPadding,
            self.contentView.bounds.size.width - CGRectGetMaxX(self.titleLabel.frame) - 2 * kFWCellPatternTableViewCellSpacingWidth,
            (self.contentView.bounds.size.height - kFWCellPatternTableViewCellVerticalPadding) / 2.0f);
}

#pragma mark - Accessors

- (void)setCellPattern:(FWCellPatternModel *)cellPattern
{
    _cellPattern = cellPattern;
    self.gameBoardView.boardSize = cellPattern.boardSize;
    self.gameBoardView.liveCells = @[cellPattern.liveCells, @[], @[]];
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    self.gameBoardView.fillColorScheme = colorScheme;
}

#pragma mark - Private Methods

- (NSArray *)liveCellsGroupedByAgeFromGameMatrix:(NSArray *)cells
{
    NSMutableArray *liveCellsArray = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];

    for (FWCellModel *cell in cells)
    {
        if (cell.alive)
        {
            [liveCellsArray[0] addObject:cell];
        }
    }

    return [liveCellsArray copy];
}

@end