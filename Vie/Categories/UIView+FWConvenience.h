//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface UIView (FWConvenience)

- (void)slideTo:(CGRect)position duration:(CGFloat)duration delay:(CGFloat)delay;
- (void)fadeInWithDuration:(CGFloat)duration delay:(CGFloat)delay;
- (CGRect)frameShiftedVerticallyByOffset:(CGFloat)offset;
- (CGRect)frameBelow;

+ (void)distributeVerticallyViews:(NSArray *)views startingAtPoint:(CGPoint)point withIncrementsOf:(CGFloat)increment;

@end