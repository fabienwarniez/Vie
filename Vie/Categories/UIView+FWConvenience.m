//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIView+FWConvenience.h"

@implementation UIView (FWConvenience)

- (void)slideTo:(CGRect)position
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = position;
                     }
                     completion:nil];
}

- (CGRect)frameBelow
{
    return CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
}

@end