//
// Created by Fabien Warniez on 2015-02-16.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTextField.h"

@implementation FWTextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 20.0f, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end