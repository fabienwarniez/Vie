//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWColorTile.h"

@implementation FWColorTile

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.mainColor = mainColor;
        self.image = image;
    }

    return self;
}

+ (instancetype)tileWithMainColor:(UIColor *)mainColor image:(UIImage *)image
{
    return [[self alloc] initWithMainColor:mainColor image:image];
}

#pragma mark - Private Methods

- (void)tileWasTapped
{
    if (!self.isSelected)
    {
        [self.delegate tileButtonWasSelected:self];
    }

    [super tileWasTapped];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.isSelected)
    {
        CGPoint imagePoint = CGPointMake(
                FWRoundFloat((self.bounds.size.width - self.image.size.width) / 2.0f),
                FWRoundFloat((self.bounds.size.height - self.image.size.height) / 2.0f)
        );

        [self.image drawAtPoint:imagePoint];
    }

    if (self.isHighlighted)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.18].CGColor);
        CGContextFillPath(context);
    }
}

@end