//
// Created by Fabien Warniez on 14-11-27.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWReflectiveTile.h"

@implementation FWReflectiveTile

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self addTarget:self action:@selector(tileWasTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];

    [self removeTarget:self action:@selector(tileWasTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    [self setNeedsDisplay];
}

- (void)tileWasTapped
{
    if (!self.isSelected)
    {
        self.selected = YES;
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

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor);
    CGContextFillPath(context);
}

@end