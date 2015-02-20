//
// Created by Fabien Warniez on 2015-02-01.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWPatternCollectionViewCell.h"
#import "FWCellPatternModel.h"
#import "FWColorSchemeModel.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

static CGFloat const kFWCellPatternBorderWidth = 1.0f;
static CGFloat const kFWCellPatternPadding = 15.0f;
static CGFloat const kFWCellPatternTitleLabelPadding = 8.0f;
static CGFloat const kFWCellPatternSizeLabelPadding = 4.0f;

@interface FWPatternCollectionViewCell ()

@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FWBoardView *gameBoardView;
@property (nonatomic, strong) UILabel *sizeLabel;

@end

@implementation FWPatternCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleBar = [[UIView alloc] initWithFrame:CGRectZero];
        _titleBar.backgroundColor = [UIColor mediumGrey];
        [self.contentView addSubview:_titleBar];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor darkBlue];
        _titleLabel.font = [UIFont smallCondensedBold];
        [_titleBar addSubview:_titleLabel];

        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.font = [UIFont microRegular];
        [self.contentView addSubview:_sizeLabel];

        _gameBoardView = [[FWBoardView alloc] init];
        _gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _gameBoardView.backgroundColor = [UIColor clearColor];
        _gameBoardView.borderWidth = kFWCellPatternBorderWidth;
        [self.contentView addSubview:_gameBoardView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleBar.frame = CGRectMake(
            0,
            self.contentView.bounds.size.height - [FWPatternCollectionViewCell titleBarHeight],
            self.contentView.bounds.size.width,
            [FWPatternCollectionViewCell titleBarHeight]
    );

    CGSize titleLabelSize = [self.titleLabel sizeThatFits:self.titleBar.bounds.size];
    if (titleLabelSize.width > self.titleBar.bounds.size.width - 2 * kFWCellPatternTitleLabelPadding)
    {
        // TODO: trigger animation
    }

    self.titleLabel.frame = CGRectMake(
            (self.titleBar.bounds.size.width - titleLabelSize.width) / 2.0f,
            (self.titleBar.bounds.size.height - titleLabelSize.height) / 2.0f,
            titleLabelSize.width,
            titleLabelSize.height
    );

    [self.sizeLabel sizeToFit];
    self.sizeLabel.frame = CGRectMake(
            self.contentView.bounds.size.width - self.sizeLabel.frame.size.width - kFWCellPatternSizeLabelPadding,
            self.contentView.bounds.size.height - [FWPatternCollectionViewCell titleBarHeight] - self.sizeLabel.frame.size.height - kFWCellPatternSizeLabelPadding,
            self.sizeLabel.frame.size.width,
            self.sizeLabel.frame.size.height
    );

    self.gameBoardView.frame = CGRectMake(
            kFWCellPatternPadding,
            kFWCellPatternPadding,
            self.contentView.bounds.size.width - 2 * kFWCellPatternPadding,
            self.contentView.bounds.size.height - 2 * kFWCellPatternPadding - [FWPatternCollectionViewCell titleBarHeight]
    );
}

- (void)prepareForReuse
{
    _mainColor = nil;
    _cellPattern = nil;
    _colorScheme = nil;
}

+ (CGFloat)titleBarHeight
{
    return 22.0f;
}

#pragma mark - Accessors

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        self.gameBoardView.fillColorScheme = [FWColorSchemeModel colorSchemeWithGuid:nil youngFillColor:[UIColor whiteColor] mediumFillColor:[UIColor whiteColor] oldFillColor:[UIColor whiteColor]];
    }
    else
    {
        self.gameBoardView.fillColorScheme = self.colorScheme;
    }
}

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
    self.sizeLabel.text = [NSString stringWithFormat:@"%lux%lu", (unsigned long) cellPattern.boardSize.numberOfColumns, (unsigned long) cellPattern.boardSize.numberOfRows];

    [self setNeedsLayout];
}

- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
{
    _colorScheme = colorScheme;
    self.gameBoardView.fillColorScheme = colorScheme;
}

- (void)setFitsOnCurrentBoard:(BOOL)fitsOnCurrentBoard
{
    _fitsOnCurrentBoard = fitsOnCurrentBoard;

    if (fitsOnCurrentBoard)
    {
        self.sizeLabel.textColor = [UIColor greenColor];
    }
    else
    {
        self.sizeLabel.textColor = [UIColor redColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddRect(context, self.bounds);

    CGContextSetFillColorWithColor(context, self.mainColor.CGColor);
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, (CGFloat) (self.bounds.size.width * 0.9), 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, (CGFloat) (self.bounds.size.width * 0.3), self.bounds.size.height);
    CGContextAddLineToPoint(context, (CGFloat) (self.bounds.size.width * 0.9), 0);

    CGContextSetFillColorWithColor(context, [UIColor buttonGrey].CGColor);
    CGContextFillPath(context);
}

@end