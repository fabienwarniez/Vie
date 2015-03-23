//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "UIView+FWConvenience.h"

@implementation UIView (FWConvenience)

- (void)slideTo:(CGRect)position duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = position;
                     }
                     completion:completion];
}

- (void)fadeInWithDuration:(CGFloat)duration delay:(CGFloat)delay
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:nil];
}

- (CGRect)frameWithY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    return frame;
}

- (CGRect)frameToTheRight
{
    return CGRectMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGRect)frameBelow
{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

+ (CGFloat)verticalSpaceToDistributeViews:(NSArray *)views inAvailableVerticalSpace:(CGFloat)height
{
    CGFloat totalViewsHeight = 0.0f;

    for (UIView *view in views) {
        totalViewsHeight += view.frame.size.height;
    }

    return FWRoundFloat((height - totalViewsHeight) / (views.count + 1));
}

+ (void)distributeVerticallyViews:(NSArray *)views startingAtPoint:(CGPoint)point withSpacing:(CGFloat)spacing
{
    CGFloat y = point.y;

    for (UIView *view in views)
    {
        view.center = CGPointMake(point.x, y);
        y += spacing + view.frame.size.height;
    }
}

@end
