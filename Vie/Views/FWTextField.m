//
// Created by Fabien Warniez on 2015-02-16.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTextField.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

@implementation FWTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }

    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat rightPadding = 10.0f;

    if (self.rightImage != nil) {
        rightPadding += 10.0f + self.rightImage.size.width;
    }
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, rightPadding));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 15.0f;
    return textRect;
}

#pragma mark - Accessors

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    if (rightImage == nil) {
        self.rightView = nil;
    } else {
        self.rightView = [[UIImageView alloc] initWithImage:rightImage];
    }
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

- (void)initialize
{
    self.backgroundColor = [UIColor lightGrey];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.font = [UIFont smallCondensed];
    self.textColor = [UIColor darkGrey];
}

@end
