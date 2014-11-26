//
// Created by Fabien Warniez on 14-11-25.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTileButton.h"
#import "UIFont+FWAppFonts.h"

@implementation FWTileButton

- (instancetype)initWithMainColor:(UIColor *)mainColor
{
    self = [super init];
    if (self)
    {
        _mainColor = mainColor;
    }

    return self;
}

+ (instancetype)buttonWithMainColor:(UIColor *)mainColor
{
    return [[self alloc] initWithMainColor:mainColor];
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

- (void)buttonPressed:(id)buttonPressed
{
    self.selected = !self.isSelected;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    [self setNeedsDisplay];
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

    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05].CGColor);
    CGContextFillPath(context);

    if (self.isHighlighted)
    {
        CGContextAddRect(context, self.bounds);

        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.18].CGColor);
        CGContextFillPath(context);
    }

    if (self.isSelected)
    {
        NSString *string = @"Selected!";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{
                NSFontAttributeName : [UIFont smallRegular],
                NSForegroundColorAttributeName : [UIColor whiteColor],
                NSParagraphStyleAttributeName: paragraphStyle
        };

        CGSize textSize = [string sizeWithAttributes:attributes];

        CGRect textFrame = CGRectMake(
                (self.bounds.size.width - textSize.width) / 2.0f,
                (self.bounds.size.height - textSize.height) / 2.0f,
                textSize.width,
                textSize.height
        );

        [string drawInRect:textFrame withAttributes:attributes];
    }
}

@end