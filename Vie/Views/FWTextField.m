//
// Created by Fabien Warniez on 2015-02-16.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTextField.h"
#import "UIColor+FWAppColors.h"
#import "UIFont+FWAppFonts.h"

@implementation FWTextField

- (id)initWithCoder:(NSCoder *)coder
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
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 50.0f));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= textRect.origin.y;
    return textRect;
}

#pragma mark - Private Methods

- (void)initialize
{
    self.backgroundColor = [UIColor lightGrey];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magnifier"]];
    self.font = [UIFont smallCondensed];
    self.textColor = [UIColor darkGrey];
}

@end