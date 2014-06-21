//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWCellPatternTableViewCell.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "FWCellPatternModel.h"
#import "FWColorSchemeModel.h"

static CGFloat const kFWCellPatternTableViewCellBorderWidth = 1.0f;
static CGFloat const kFWCellPatternTableViewCellSpacingWidth = 15.0f;
static CGFloat const kFWCellPatternTableViewCellLabelWidth = 80.0f;
static CGFloat const kFWCellPatternTableViewCellVerticalPadding = 10.0f;

@interface FWCellPatternTableViewCell ()

@property (nonatomic, strong) FWBoardView *gameBoardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) FWBoardSizeModel * boardSize;

@end

@implementation FWCellPatternTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_titleLabel];

        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:_sizeLabel];

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

    CGSize sizeLabelSize = [self.sizeLabel sizeThatFits:CGSizeMake(kFWCellPatternTableViewCellLabelWidth, self.contentView.bounds.size.height)];
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(kFWCellPatternTableViewCellLabelWidth, sizeLabelSize.height)];

    self.titleLabel.frame = CGRectMake(
            kFWCellPatternTableViewCellSpacingWidth,
            5.0f,
            kFWCellPatternTableViewCellLabelWidth,
            titleLabelSize.height);
    self.sizeLabel.frame = CGRectMake(
            kFWCellPatternTableViewCellSpacingWidth,
            self.bounds.size.height - sizeLabelSize.height - 5.0f,
            kFWCellPatternTableViewCellLabelWidth,
            sizeLabelSize.height);
    self.gameBoardView.frame = CGRectMake(
            CGRectGetMaxX(self.titleLabel.frame) + kFWCellPatternTableViewCellSpacingWidth,
            kFWCellPatternTableViewCellVerticalPadding,
            self.contentView.bounds.size.width - CGRectGetMaxX(self.titleLabel.frame) - 2 * kFWCellPatternTableViewCellSpacingWidth,
            self.contentView.bounds.size.height - 2 * kFWCellPatternTableViewCellVerticalPadding);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [self setHighlighted:highlighted animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];

    if (highlighted)
    {
        self.gameBoardView.fillColorScheme = [FWColorSchemeModel colorSchemeWithGuid:nil youngFillColor:[UIColor whiteColor] mediumFillColor:[UIColor whiteColor] oldFillColor:[UIColor whiteColor]];
    }
    else
    {
        self.gameBoardView.fillColorScheme = self.colorScheme;
    }
}

- (void)setFitsOnCurrentBoard:(BOOL)fitsOnCurrentBoard
{
    _fitsOnCurrentBoard = fitsOnCurrentBoard;

    if (fitsOnCurrentBoard)
    {
        self.sizeLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        self.sizeLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - Accessors

- (void)setCellPattern:(FWCellPatternModel *)cellPattern
{
    _cellPattern = cellPattern;
    if ([cellPattern.boardSize isSmallerOrEqualToBoardSize:[FWBoardSizeModel boardSizeWithName:nil numberOfColumns:90 numberOfRows:120]])
    {
        self.gameBoardView.boardSize = cellPattern.boardSize;
        self.gameBoardView.liveCells = @[cellPattern.liveCells, @[], @[]];
    }
    else
    {
        self.gameBoardView.liveCells = nil;
    }
    self.titleLabel.text = cellPattern.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"%dx%d", cellPattern.boardSize.numberOfColumns, cellPattern.boardSize.numberOfRows];
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    self.gameBoardView.fillColorScheme = colorScheme;
}

@end