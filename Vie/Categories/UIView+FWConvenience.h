//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface UIView (FWConvenience)

- (void)slideTo:(CGRect)position duration:(CGFloat)duration delay:(CGFloat)delay completion:(void (^)(BOOL finished))completion;
- (void)fadeInWithDuration:(CGFloat)duration delay:(CGFloat)delay;

- (CGRect)frameWithY:(CGFloat)y;

- (CGRect)frameToTheRight;
- (CGRect)frameBelow;

+ (CGFloat)verticalSpaceToDistributeViews:(NSArray *)views inAvailableVerticalSpace:(CGFloat)height;
+ (void)distributeVerticallyViews:(NSArray *)views startingAtPoint:(CGPoint)point withSpacing:(CGFloat)spacing;

@end