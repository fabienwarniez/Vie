//
// Created by Fabien Warniez on 14-12-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameToolbar.h"
#import "UIColor+FWAppColors.h"

static CGFloat const kFWButtonSpacing = 36.0f;

@interface FWGameToolbar ()

@property (nonatomic, strong) UIButton *rewindButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *fastForwardButton;

@end

@implementation FWGameToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self setup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if (self)
    {
        [self setup];
    }

    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor vieGreen];

    _rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rewindButton setImage:[UIImage imageNamed:@"rewind"] forState:UIControlStateNormal];
    [_rewindButton addTarget:self action:@selector(rewindButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    _fastForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fastForwardButton setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [_fastForwardButton addTarget:self action:@selector(fastForwardButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_rewindButton];
    [self addSubview:_playButton];
    [self addSubview:_fastForwardButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.rewindButton sizeToFit];
    [self.playButton sizeToFit];
    [self.fastForwardButton sizeToFit];

    CGFloat totalWidth = self.rewindButton.frame.size.width + self.playButton.frame.size.width + self.fastForwardButton.frame.size.width + 2 * kFWButtonSpacing;

    self.rewindButton.center = CGPointMake((self.bounds.size.width - totalWidth + self.rewindButton.frame.size.width) / 2.0f, self.bounds.size.height / 2.0f);
    self.playButton.center = CGPointMake(self.center.x, self.bounds.size.height / 2.0f);
    self.fastForwardButton.center = CGPointMake((self.bounds.size.width + totalWidth - self.rewindButton.frame.size.width) / 2.0f, self.bounds.size.height / 2.0f);
}

- (void)rewindButtonTapped
{
    [self.delegate rewindButtonTappedFor:self];
}

- (void)playButtonTapped
{
    [self.delegate playButtonTappedFor:self];
}

- (void)fastForwardButtonTapped
{
    [self.delegate fastForwardButtonTappedFor:self];
}

@end