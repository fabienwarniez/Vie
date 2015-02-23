//
// Created by Fabien Warniez on 2015-02-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "UIScrollView+FWConvenience.h"

@implementation UIScrollView (FWConvenience)

- (CGFloat)topY
{
    return self.contentOffset.y + self.contentInset.top;
}

- (CGFloat)bottomY
{
    return self.contentOffset.y - self.contentInset.bottom + self.bounds.size.height;
}

- (BOOL)isBouncingAtTop
{
    return [self topY] <= 0;
}

- (BOOL)isBouncingAtBottom
{
    return [self bottomY] >= self.contentSize.height;
}

@end
