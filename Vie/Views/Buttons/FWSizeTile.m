//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSizeTile.h"
#import "UIColor+FWAppColors.h"

@implementation FWSizeTile

- (instancetype)initWithMainColor:(UIColor *)mainColor squareColor:(UIColor *)squareColor squareWidthAsPercentage:(NSUInteger)percentage
{
    self = [super init];
    if (self)
    {
        self.mainColor = mainColor;
        _squareColor = squareColor;
        _widthAsPercentage = percentage;
    }

    return self;
}

+ (instancetype)buttonWithMainColor:(UIColor *)mainColor squareColor:(UIColor *)squareColor squareWidthAsPercentage:(NSUInteger)percentage
{
    return [[self alloc] initWithMainColor:mainColor squareColor:squareColor squareWidthAsPercentage:percentage];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self addTarget:self action:@selector(buttonWasTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];

    [self removeTarget:self action:@selector(buttonWasTapped) forControlEvents:UIControlEventTouchUpInside];
}

+ (NSUInteger)squarePercentageForSizeIndex:(NSUInteger)index
{
    NSUInteger percent = 0;

    if (index == 1)
    {
        percent = 50;
    }
    else if (index == 2)
    {
        percent = 35;
    }
    else if (index == 3)
    {
        percent = 20;
    }
    else if (index == 4)
    {
        percent = 5;
    }

    return percent;
}

#pragma mark - Private Methods

- (void)buttonWasTapped
{
    if (!self.isSelected)
    {
        self.selected = YES;

        [self.delegate sizeTileWasSelected:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat squareWidth = self.bounds.size.width * self.widthAsPercentage / 100.0f;
    CGFloat squareHeight = self.bounds.size.height * self.widthAsPercentage / 100.0f;

    CGRect squareRect = CGRectMake((self.bounds.size.width - squareWidth) / 2.0f, (self.bounds.size.height - squareHeight) / 2.0f, squareWidth, squareHeight);
    CGContextAddRect(context, squareRect);
    CGContextSetFillColorWithColor(context, [UIColor vieGreen].CGColor);
    CGContextFillPath(context);

    if (self.isSelected)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.18].CGColor);
        CGContextFillPath(context);
    }

    if (self.isHighlighted)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.18].CGColor);
        CGContextFillPath(context);
    }
}

@end