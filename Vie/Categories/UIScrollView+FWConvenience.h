//
// Created by Fabien Warniez on 2015-02-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@interface UIScrollView (FWConvenience)

- (CGFloat)topY;
- (CGFloat)bottomY;
- (BOOL)isBouncingAtTop;
- (BOOL)isBouncingAtBottom;

@end