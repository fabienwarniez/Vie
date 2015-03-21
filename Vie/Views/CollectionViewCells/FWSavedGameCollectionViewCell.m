//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWSavedGameCollectionViewCell.h"
#import "FWSavedGameModel.h"
#import "FWBoardSizeModel.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

static CGFloat const kFWCellSavedGamePadding = 15.0f;
static CGFloat const kFWCellSavedGameTitleLabelPadding = 8.0f;
static CGFloat const kFWCellSavedGameOptionsButtonPadding = 15.0f;

@interface FWSavedGameCollectionViewCell ()

@property (nonatomic, strong) UIView *flipContainer;
@property (nonatomic, strong) UIView *nonSelectedContainer;
@property (nonatomic, strong) UIView *selectedContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation FWSavedGameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _flipContainer = [[UIView alloc] init];
        [self.contentView addSubview:_flipContainer];

        _nonSelectedContainer = [[UIView alloc] init];
        [_flipContainer addSubview:_nonSelectedContainer];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor darkBlue];
        _titleLabel.font = [UIFont largeCondensedBold];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.minimumScaleFactor = 0.5f;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [_nonSelectedContainer addSubview:_titleLabel];

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor darkBlue];
        _dateLabel.font = [UIFont smallCondensed];
        [_nonSelectedContainer addSubview:_dateLabel];

        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.textColor = [UIColor darkBlue];
        _sizeLabel.font = [UIFont smallCondensed];
        [_nonSelectedContainer addSubview:_sizeLabel];

        _selectedContainer = [[UIView alloc] init];
        _selectedContainer.backgroundColor = [UIColor darkBlue];
        [_selectedContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)]];

        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"large-play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"large-play-active"] forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedContainer addSubview:_playButton];

        _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionsButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_optionsButton setImage:[UIImage imageNamed:@"more-active"] forState:UIControlStateSelected];
        [_optionsButton addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedContainer addSubview:_optionsButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.flipContainer.frame = self.contentView.bounds;
    self.nonSelectedContainer.frame = self.contentView.bounds;
    self.selectedContainer.frame = self.contentView.bounds;

    CGRect availableFrame = UIEdgeInsetsInsetRect(self.nonSelectedContainer.bounds, UIEdgeInsetsMake(22.0f, kFWCellSavedGamePadding, 60.0f, kFWCellSavedGamePadding));

    CGSize titleLabelSize = [self.titleLabel sizeThatFits:availableFrame.size];

    self.titleLabel.frame = CGRectMake(
            availableFrame.origin.x,
            availableFrame.origin.y,
            availableFrame.size.width,
            MIN(titleLabelSize.height, availableFrame.size.height)
    );

    [self.sizeLabel sizeToFit];
    self.sizeLabel.frame = CGRectMake(
            (self.nonSelectedContainer.bounds.size.width - self.sizeLabel.frame.size.width) / 2.0f,
            self.nonSelectedContainer.bounds.size.height - self.sizeLabel.frame.size.height - 15.0f,
            self.sizeLabel.frame.size.width,
            self.sizeLabel.frame.size.height
    );

    [self.dateLabel sizeToFit];
    self.dateLabel.frame = CGRectMake(
            (self.nonSelectedContainer.bounds.size.width - self.dateLabel.frame.size.width) / 2.0f,
            self.sizeLabel.frame.origin.y - self.dateLabel.frame.size.height - 0.0f,
            self.dateLabel.frame.size.width,
            self.dateLabel.frame.size.height
    );

    self.playButton.frame = CGRectMake(
            (self.selectedContainer.bounds.size.width - 76.0f) / 2.0f,
            (self.selectedContainer.bounds.size.height - 76.0f) / 2.0f,
            76.0f,
            76.0f
    );

    CGSize optionsIconSize = [self.optionsButton imageForState:UIControlStateNormal].size;
    optionsIconSize.width += 2 * kFWCellSavedGameOptionsButtonPadding;
    optionsIconSize.height += 2 * kFWCellSavedGameOptionsButtonPadding;
    self.optionsButton.frame = CGRectMake(
            0,
            self.selectedContainer.bounds.size.height - optionsIconSize.height,
            optionsIconSize.width,
            optionsIconSize.height
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
    self.savedGame = nil;
    [self setSelected:NO animated:NO];
}

#pragma mark - Accessors

- (void)setSavedGame:(FWSavedGameModel *)savedGame
{
    self.titleLabel.text = savedGame.name;
    self.dateLabel.text = [self formattedDate:savedGame.creationDate];
    self.sizeLabel.text = [NSString stringWithFormat:@"%lux%lu", (unsigned long) savedGame.boardSize.numberOfColumns, (unsigned long) savedGame.boardSize.numberOfRows];

    [self setNeedsLayout];
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

#pragma mark - Private Methods

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
                             frame.origin.x = label.frame.size.width + 2 * kFWCellSavedGameTitleLabelPadding;
                             label.frame = frame;
                             [self animateLabel:label withDuration:8.0f];
                         }
                     }];
}

- (void)playButtonTapped:(UIButton *)sender
{
    [self.delegate playButtonTappedForSavedGameCollectionViewCell:self];
}

- (void)optionsButtonTapped:(UIButton *)optionsButton
{
    [self.delegate optionsButtonTappedForSavedGameCollectionViewCell:self];
}

- (void)backgroundTapped
{
    [self.delegate savedGameCollectionViewCellDidCancel:self];
}

- (NSString *)formattedDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:date];
}

@end
