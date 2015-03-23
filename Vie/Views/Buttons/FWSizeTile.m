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

+ (instancetype)tileWithMainColor:(UIColor *)mainColor squareColor:(UIColor *)squareColor squareWidthAsPercentage:(NSUInteger)percentage
{
    return [[self alloc] initWithMainColor:mainColor squareColor:squareColor squareWidthAsPercentage:percentage];
}

#pragma mark - Private Methods

- (void)tileWasTapped
{
    if (!self.isSelected)
    {
        [self.delegate sizeTileWasSelected:self];
    }

    [super tileWasTapped];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat squareWidth = FWRoundFloat(self.bounds.size.width * self.widthAsPercentage / 100.0f);
    CGFloat squareHeight = FWRoundFloat(self.bounds.size.height * self.widthAsPercentage / 100.0f);

    CGRect squareRect = CGRectMake(
            FWRoundFloat((self.bounds.size.width - squareWidth) / 2.0f),
            FWRoundFloat((self.bounds.size.height - squareHeight) / 2.0f),
            squareWidth,
            squareHeight
    );
    CGContextAddRect(context, squareRect);
    CGContextSetFillColorWithColor(context, [UIColor vieGreen].CGColor);
    CGContextFillPath(context);

    if (self.isHighlighted)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.36].CGColor);
        CGContextFillPath(context);
    }
    else if (self.isSelected)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.18].CGColor);
        CGContextFillPath(context);
    }
}

@end