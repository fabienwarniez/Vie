//
// Created by Fabien Warniez on 14-12-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

@interface FWTitleBar ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation FWTitleBar

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
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont largeBold];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor vieGreenDark];
    [_button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_label];
    [self addSubview:_button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.label.text = [self.delegate titleFor:self];
    [self.label sizeToFit];
    self.label.center = self.center;

    self.button.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.button setImage:[self.delegate buttonImageFor:self] forState:UIControlStateNormal];
}

- (void)buttonTapped
{
    [self.delegate buttonTappedFor:self];
}

@end