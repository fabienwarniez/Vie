//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWSizeButton.h"
#import "UIColor+FWAppColors.h"

@implementation FWSizeButton

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

+ (instancetype)buttonWithMainColor:(UIColor *)mainColor image:(UIImage *)image
{
    return [[self alloc] initWithMainColor:mainColor image:image];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];

    [self removeTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private Methods

- (void)buttonPressed:(id)buttonPressed
{
    if (!self.isSelected)
    {
        self.selected = YES;

        [self.delegate tileButtonWasSelected:self];
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

    CGRect squareRect = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
    CGContextAddRect(context, squareRect);
    CGContextSetFillColorWithColor(context, [UIColor colorWithDecimalRed:27 green:206 blue:124].CGColor);
    CGContextFillPath(context);
}

@end