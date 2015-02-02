//
// Created by Fabien Warniez on 2015-02-01.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWPatternCollectionViewCell.h"
#import "FWCellPatternModel.h"
#import "FWColorSchemeModel.h"

@implementation FWPatternCollectionViewCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self)
//    {
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.textColor = [UIColor darkGrayColor];
//        _titleLabel.numberOfLines = 0;
//        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
//        [self.contentView addSubview:_titleLabel];
//
//        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _sizeLabel.font = [UIFont systemFontOfSize:10.0f];
//        [self.contentView addSubview:_sizeLabel];
//
//        _gameBoardView = [[FWBoardView alloc] init];
//        _gameBoardView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
//        _gameBoardView.backgroundColor = [UIColor clearColor];
//        _gameBoardView.borderWidth = kFWCellPatternTableViewCellBorderWidth;
//        [self.contentView addSubview:_gameBoardView];
//    }
//    return self;
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    CGSize sizeLabelSize = [self.sizeLabel sizeThatFits:CGSizeMake(kFWCellPatternTableViewCellLabelWidth, self.contentView.bounds.size.height)];
//    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(kFWCellPatternTableViewCellLabelWidth, sizeLabelSize.height)];
//
//    self.titleLabel.frame = CGRectMake(
//            kFWCellPatternTableViewCellSpacingWidth,
//            5.0f,
//            kFWCellPatternTableViewCellLabelWidth,
//            titleLabelSize.height);
//    self.sizeLabel.frame = CGRectMake(
//            kFWCellPatternTableViewCellSpacingWidth,
//            self.bounds.size.height - sizeLabelSize.height - 5.0f,
//            kFWCellPatternTableViewCellLabelWidth,
//            sizeLabelSize.height);
//    self.gameBoardView.frame = CGRectMake(
//            CGRectGetMaxX(self.titleLabel.frame) + kFWCellPatternTableViewCellSpacingWidth,
//            kFWCellPatternTableViewCellVerticalPadding,
//            self.contentView.bounds.size.width - CGRectGetMaxX(self.titleLabel.frame) - 2 * kFWCellPatternTableViewCellSpacingWidth,
//            self.contentView.bounds.size.height - 2 * kFWCellPatternTableViewCellVerticalPadding);
//}
//
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [self setHighlighted:highlighted animated:NO];
//}
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//
//    if (highlighted)
//    {
//        self.gameBoardView.fillColorScheme = [FWColorSchemeModel colorSchemeWithGuid:nil youngFillColor:[UIColor whiteColor] mediumFillColor:[UIColor whiteColor] oldFillColor:[UIColor whiteColor]];
//    }
//    else
//    {
//        self.gameBoardView.fillColorScheme = self.colorScheme;
//    }
//}
//
//- (void)setFitsOnCurrentBoard:(BOOL)fitsOnCurrentBoard
//{
//    _fitsOnCurrentBoard = fitsOnCurrentBoard;
//
//    if (fitsOnCurrentBoard)
//    {
//        self.sizeLabel.textColor = [UIColor lightGrayColor];
//    }
//    else
//    {
//        self.sizeLabel.textColor = [UIColor redColor];
//    }
//}
//
//#pragma mark - Accessors
//
//- (void)setCellPattern:(FWCellPatternModel *)cellPattern
//{
//    _cellPattern = cellPattern;
//    if ([cellPattern.boardSize isSmallerOrEqualToBoardSize:[FWBoardSizeModel boardSizeWithName:nil numberOfColumns:90 numberOfRows:120]])
//    {
//        self.gameBoardView.boardSize = cellPattern.boardSize;
//        self.gameBoardView.liveCells = @[cellPattern.liveCells, @[], @[]];
//    }
//    else
//    {
//        self.gameBoardView.liveCells = nil;
//    }
//    self.titleLabel.text = cellPattern.name;
//    self.sizeLabel.text = [NSString stringWithFormat:@"%lux%lu", (unsigned long) cellPattern.boardSize.numberOfColumns, (unsigned long) cellPattern.boardSize.numberOfRows];
//}
//
//- (void)setColorScheme:(FWColorSchemeModel *)colorScheme
//{
//    _colorScheme = colorScheme;
//    self.gameBoardView.fillColorScheme = colorScheme;
//}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddRect(context, self.bounds);

    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//    CGContextSetFillColorWithColor(context, self.mainColor.CGColor);
    CGContextFillPath(context);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, (CGFloat) (self.bounds.size.width * 0.9), 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, (CGFloat) (self.bounds.size.width * 0.3), self.bounds.size.height);
    CGContextAddLineToPoint(context, (CGFloat) (self.bounds.size.width * 0.9), 0);

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor);
    CGContextFillPath(context);
}

@end