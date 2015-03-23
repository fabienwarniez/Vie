//
// Created by Fabien Warniez on 2015-02-01.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWPatternCollectionViewCell.h"
#import "FWPatternModel.h"
#import "FWColorSchemeModel.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

static CGFloat const kFWCellPatternBorderWidth = 1.0f;
static CGFloat const kFWCellPatternPadding = 15.0f;
static CGFloat const kFWCellPatternTitleLabelPadding = 8.0f;
static CGFloat const kFWCellPatternSizeLabelPadding = 4.0f;
static CGFloat const kFWCellPatternFavouriteButtonPadding = 9.0f;

@interface FWPatternCollectionViewCell ()

@property (nonatomic, strong) UIView *flipContainer;
@property (nonatomic, strong) UIView *nonSelectedContainer;
@property (nonatomic, strong) UIView *selectedContainer;
@property (nonatomic, strong) UIView *titleBar;
@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) FWBoardView *gameBoardView;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *favouriteButton;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation FWPatternCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleBar = [[UIView alloc] init];
        _titleBar.backgroundColor = [UIColor mediumGrey];
        _titleBar.clipsToBounds = YES;
        [self.contentView addSubview:_titleBar];

        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = [UIColor darkBlue];
        _titleLabel1.font = [UIFont smallCondensedBold];
        [_titleBar addSubview:_titleLabel1];

        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = [UIColor darkBlue];
        _titleLabel2.font = [UIFont smallCondensedBold];
        [_titleBar addSubview:_titleLabel2];

        _flipContainer = [[UIView alloc] init];
        [self.contentView addSubview:_flipContainer];

        _nonSelectedContainer = [[UIView alloc] init];
        [_flipContainer addSubview:_nonSelectedContainer];

        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.font = [UIFont microRegular];
        [_nonSelectedContainer addSubview:_sizeLabel];

        _gameBoardView = [[FWBoardView alloc] initWithFrame:CGRectZero];
        _gameBoardView.backgroundColor = [UIColor clearColor];
        _gameBoardView.borderWidth = kFWCellPatternBorderWidth;
        [_nonSelectedContainer addSubview:_gameBoardView];

        _selectedContainer = [[UIView alloc] init];
        _selectedContainer.backgroundColor = [UIColor darkBlue];
        [_selectedContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)]];

        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"large-play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"large-play-active"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedContainer addSubview:_playButton];

        _favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favouriteButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [_favouriteButton setImage:[UIImage imageNamed:@"heart-selected"] forState:UIControlStateSelected];
        [_favouriteButton addTarget:self action:@selector(favouritedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedContainer addSubview:_favouriteButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect containerFrame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.width);

    self.flipContainer.frame = containerFrame;
    self.nonSelectedContainer.frame = containerFrame;
    self.selectedContainer.frame = containerFrame;

    self.titleBar.frame = CGRectMake(
            0,
            self.contentView.bounds.size.height - [FWPatternCollectionViewCell titleBarHeight],
            self.contentView.bounds.size.width,
            [FWPatternCollectionViewCell titleBarHeight]
    );

    CGSize titleLabelSize = [self.titleLabel1 sizeThatFits:self.titleBar.bounds.size];
    CGPoint titleLabelPoint = CGPointMake(0, FWRoundFloat((self.titleBar.bounds.size.height - titleLabelSize.height) / 2.0f));
    if (titleLabelSize.width > self.titleBar.bounds.size.width - 2 * kFWCellPatternTitleLabelPadding)
    {
        titleLabelPoint.x = kFWCellPatternTitleLabelPadding;
        self.titleLabel1.frame = CGRectMake(titleLabelPoint.x, titleLabelPoint.y, titleLabelSize.width, titleLabelSize.height);
        self.titleLabel2.frame = CGRectMake(2 * kFWCellPatternTitleLabelPadding + titleLabelSize.width, titleLabelPoint.y, titleLabelSize.width, titleLabelSize.height);
        self.titleLabel2.hidden = NO;

        [self startRolling];
    }
    else
    {
        titleLabelPoint.x = FWRoundFloat((self.titleBar.bounds.size.width - titleLabelSize.width) / 2.0f);
        self.titleLabel1.frame = CGRectMake(titleLabelPoint.x, titleLabelPoint.y, titleLabelSize.width, titleLabelSize.height);
        self.titleLabel2.hidden = YES;
    }

    [self.sizeLabel sizeToFit];
    self.sizeLabel.frame = CGRectMake(
            self.nonSelectedContainer.bounds.size.width - self.sizeLabel.frame.size.width - kFWCellPatternSizeLabelPadding,
            self.nonSelectedContainer.bounds.size.height - self.sizeLabel.frame.size.height - kFWCellPatternSizeLabelPadding,
            self.sizeLabel.frame.size.width,
            self.sizeLabel.frame.size.height
    );

    self.gameBoardView.frame = CGRectMake(
            kFWCellPatternPadding,
            kFWCellPatternPadding,
            self.nonSelectedContainer.bounds.size.width - 2 * kFWCellPatternPadding,
            self.nonSelectedContainer.bounds.size.height - 2 * kFWCellPatternPadding
    );

    self.playButton.frame = CGRectMake(
            FWRoundFloat((self.selectedContainer.bounds.size.width - 76.0f) / 2.0f),
            FWRoundFloat((self.selectedContainer.bounds.size.height - 76.0f) / 2.0f),
            76.0f,
            76.0f
    );

    CGSize favouriteIconSize = [self.favouriteButton imageForState:UIControlStateNormal].size;
    favouriteIconSize.width += 2 * kFWCellPatternFavouriteButtonPadding;
    favouriteIconSize.height += 2 * kFWCellPatternFavouriteButtonPadding;
    self.favouriteButton.frame = CGRectMake(
            0,
            self.selectedContainer.bounds.size.height - favouriteIconSize.height,
            favouriteIconSize.width,
            favouriteIconSize.height
    );
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected];

    if (animated)
    {
        if (selected)
        {
            [UIView transitionFromView:self.nonSelectedContainer
                                toView:self.selectedContainer
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            completion:^(BOOL finished) {
                            }];
        }
        else
        {
            [UIView transitionFromView:self.selectedContainer
                                toView:self.nonSelectedContainer
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            completion:^(BOOL finished) {
                            }];
        }
    }
    else
    {
        if (selected)
        {
            [self.nonSelectedContainer removeFromSuperview];
            [self.flipContainer addSubview:self.selectedContainer];
        }
        else
        {
            [self.selectedContainer removeFromSuperview];
            [self.flipContainer addSubview:self.nonSelectedContainer];
        }
    }
}

- (void)prepareForReuse
{
    self.mainColor = nil;
    self.cellPattern = nil;
    self.colorScheme = nil;
    [self.titleLabel1.layer removeAllAnimations];
    [self.titleLabel2.layer removeAllAnimations];
    [self setSelected:NO animated:NO];
    [self.favouriteButton setSelected:NO];
}

+ (CGFloat)titleBarHeight
{
    return 22.0f;
}

#pragma mark - Accessors

- (void)setCellPattern:(FWPatternModel *)cellPattern
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
    self.titleLabel1.text = cellPattern.name;
    self.titleLabel2.text = cellPattern.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"%lux%lu", (unsigned long) cellPattern.boardSize.numberOfColumns, (unsigned long) cellPattern.boardSize.numberOfRows];
    [self.favouriteButton setSelected:cellPattern.favourited];

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
    CGContextMoveToPoint(context, FWRoundFloat((self.bounds.size.width * 0.9)), 0.0);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextAddLineToPoint(context, FWRoundFloat((self.bounds.size.width * 0.3)), self.bounds.size.height);
    CGContextAddLineToPoint(context, FWRoundFloat((self.bounds.size.width * 0.9)), 0);

    CGContextSetFillColorWithColor(context, [UIColor buttonGrey].CGColor);
    CGContextFillPath(context);
}

#pragma mark - Private Methods

- (void)startRolling
{
    [self animateLabel:self.titleLabel1 withDuration:4.0f];
    [self animateLabel:self.titleLabel2 withDuration:8.0f];
}

- (void)animateLabel:(UILabel *)label withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = label.frame;
                         frame.origin.x = -label.frame.size.width;
                         label.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                         {
                             CGRect frame = label.frame;
                             frame.origin.x = label.frame.size.width + 2 * kFWCellPatternTitleLabelPadding;
                             label.frame = frame;
                             [self animateLabel:label withDuration:8.0f];
                         }
                     }];
}

- (void)favouritedButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if (sender.selected)
    {
        [self.delegate favouriteButtonTappedFor:self];
    }
    else
    {
        [self.delegate unfavouriteButtonTappedFor:self];
    }
}

- (void)playButtonTapped:(UIButton *)sender
{
    [self.delegate playButtonTappedFor:self];
}

- (void)backgroundTapped
{
    [self.delegate patternCollectionViewCellDidCancel:self];
}

@end