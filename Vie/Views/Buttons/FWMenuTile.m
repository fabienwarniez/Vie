//
// Created by Fabien Warniez on 15-01-25.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWMenuTile.h"
#import "UIFont+FWAppFonts.h"
#import "UIColor+FWAppColors.h"

@implementation FWMenuTile

- (instancetype)initWithMainColor:(UIColor *)mainColor image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    if (self)
    {
        self.mainColor = mainColor;
        self.image = image;
        self.title = title;
        self.subTitle = subTitle;
    }
    return self;
}

+ (instancetype)tileWithMainColor:(UIColor *)mainColor image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle
{
    return [[self alloc] initWithMainColor:mainColor image:image title:title subTitle:subTitle];
}

#pragma mark - Private Methods

- (void)tileWasTapped
{
    [self.delegate tileButtonWasSelected:self];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    NSDictionary *mainTitleAttributes = @{
            NSForegroundColorAttributeName:[UIColor vieGreen],
            NSFontAttributeName:[UIFont largeRegular]
    };
    CGSize mainTitleSize = [self.title sizeWithAttributes:mainTitleAttributes];

    CGFloat imageX = (self.bounds.size.width - self.image.size.width) / 2.0f;
    CGFloat imageY = (self.bounds.size.height - (mainTitleSize.height + self.image.size.height + 12.0f)) / 2.0f;

    [self.image drawAtPoint:CGPointMake(imageX, imageY)];

    CGFloat mainTitleX = (self.bounds.size.width - mainTitleSize.width) / 2.0f;
    CGFloat mainTitleY = imageY + self.image.size.height + 12.0f;

    [self.title drawInRect:CGRectMake(mainTitleX, mainTitleY, mainTitleSize.width, mainTitleSize.height) withAttributes:mainTitleAttributes];

    if (self.subTitle)
    {
        NSDictionary *subtitleAttributes = @{
                NSForegroundColorAttributeName:[UIColor vieGreen],
                NSFontAttributeName:[UIFont tinyRegular]
        };
        CGSize subTitleSize = [self.subTitle sizeWithAttributes:subtitleAttributes];

        CGFloat subTitleX = (self.bounds.size.width - subTitleSize.width) / 2.0f;
        CGFloat subTitleY = mainTitleY + mainTitleSize.height + 0.0f;

        [self.subTitle drawInRect:CGRectMake(subTitleX, subTitleY, subTitleSize.width, subTitleSize.height) withAttributes:subtitleAttributes];
    }

    if (self.isSelected)
    {
        CGPoint imagePoint = CGPointMake(
                (self.bounds.size.width - self.image.size.width) / 2.0f,
                (self.bounds.size.height - self.image.size.height) / 2.0f
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